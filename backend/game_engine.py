import matplotlib
matplotlib.use('TkAgg') 

import os
import pandas as pd
import pyarrow.parquet as pq
import matplotlib.pyplot as plt
import matplotlib.animation as animation
import matplotlib.image as mpimg
import numpy as np

from data_engine import DataEngine

# --- MAP CONFIGURATIONS ---
MAP_CONFIGS = {
    "AmbroseValley": {"scale": 900,  "origin_x": -370, "origin_z": -473, "img": "minimaps/AmbroseValley_Minimap.png"},
    "GrandRift":     {"scale": 581,  "origin_x": -290, "origin_z": -290, "img": "minimaps/GrandRift_Minimap.png"},
    "Lockdown":      {"scale": 1000, "origin_x": -500, "origin_z": -500, "img": "minimaps/Lockdown_Minimap.jpg"}
}

def find_match_by_map(folder_path, target_map):
    """Scans files quickly to find the first match_id that occurred on the target map."""
    print(f"Scouting '{folder_path}' for a match on '{target_map}'...")
    
    if not os.path.exists(folder_path):
        print(f"Error: Directory '{folder_path}' not found.")
        return None

    for filename in os.listdir(folder_path):
        if not filename.endswith('.nakama-0'):
            continue
            
        filepath = os.path.join(folder_path, filename)
        try:
            table = pq.read_table(filepath, columns=['match_id', 'map_id'])
            df = table.to_pandas()
            if not df.empty and df['map_id'].iloc[0] == target_map:
                found_match_id = df['match_id'].iloc[0]
                print("found_match_id>>", found_match_id)
                # Clean the match_id to ensure perfect matching later

                clean_match_id = found_match_id.replace('.nakama-0', '')
                print(f"Success! Found match: {clean_match_id}")
                return clean_match_id
        except Exception:
            continue
            
    print(f"Could not find any matches on {target_map} in this folder.")
    return None

def load_specific_match(folder_path, target_match_id):
    """Scans the folder and ONLY loads files matching the target match_id."""
    print(f"Loading full telemetry for match: {target_match_id[:13]}...")
    frames = []
    
    for filename in os.listdir(folder_path):
        if not filename.endswith('.nakama-0'):
            continue
            
        # Safely isolate the match_id from the filename: {user_id}_{match_id}.nakama-0
        parts = filename.split('_')
        if len(parts) >= 2:
            file_match_id = parts[-1].replace('.nakama-0', '')
            
            # If it belongs to our match, load it
            if file_match_id == target_match_id:
                filepath = os.path.join(folder_path, filename)
                try:
                    table = pq.read_table(filepath)
                    df = table.to_pandas()
                    frames.append(df)
                except Exception as e:
                    print(f"Failed to load {filename}: {e}") # Expose errors instead of silently skipping
                    continue
            
    if not frames:
        print("No valid data frames were constructed.")
        return pd.DataFrame()
        
    match_df = pd.concat(frames, ignore_index=True)
    
    # 1. Decode event bytes
    if 'event' in match_df.columns:
        match_df['event'] = match_df['event'].apply(
            lambda x: x.decode('utf-8') if isinstance(x, bytes) else x
        )
        
    # 2. FORCE user_id to string to prevent pandas from confusing bot ints and human strings
    match_df['user_id'] = match_df['user_id'].astype(str)
    
    # Console Verification
    total_unique_users = match_df['user_id'].unique()
    humans_loaded = sum(1 for uid in total_unique_users if is_human(uid))
    bots_loaded = sum(1 for uid in total_unique_users if is_bot(uid))
    print(f"Data Load Complete -> Events: {len(match_df)} | Humans: {humans_loaded} | Bots: {bots_loaded}")
    
    return match_df

def is_bot(user_id):
    return str(user_id).isdigit()

def is_human(user_id):
    return not str(user_id).isdigit()

def convert_to_minimap_coords(df, map_id):
    """Converts 3D world coordinates (X, Z) to 2D minimap pixel coordinates."""
    config = MAP_CONFIGS.get(map_id)
    scale = config["scale"]
    origin_x = config["origin_x"]
    origin_z = config["origin_z"]
    
    u = (df['x'] - origin_x) / scale
    v = (df['z'] - origin_z) / scale
    
    df['pixel_x'] = u * 1024
    df['pixel_y'] = (1 - v) * 1024
    
    return df

def play_match(match_df):
    """Sorts data by time and animates the gameplay in real-time."""
    if match_df.empty:
        return
        
    match_df = match_df.sort_values(by='ts').reset_index(drop=True)
    match_id = match_df['match_id'].iloc[0]
    map_id = match_df['map_id'].iloc[0]
    
    match_df = convert_to_minimap_coords(match_df, map_id)
    
    fig, ax = plt.subplots(figsize=(8, 8))
    
    try:
        img_path = MAP_FOLDER + "/" +MAP_CONFIGS[map_id]["img"]
        print("img_path>" , img_path)
        img = mpimg.imread(img_path)
        ax.imshow(img, extent=[0, 1024, 1024, 0])
    except FileNotFoundError:
        print("Warning: Minimap image not found. Playing on blank canvas.")
        ax.set_xlim(0, 1024)
        ax.set_ylim(1024, 0)
        
    ax.set_title(f"Map: {map_id}\nMatch ID: {match_id[:13]}...")
    ax.axis('off') 
    
    # Render Humans as highly visible green dots, and Bots as smaller red dots
    human_scatter = ax.scatter([], [], c='#00ff00', s=45, label='Humans', edgecolors='black', zorder=3)
    bot_scatter = ax.scatter([], [], c='#ff0000', s=15, label='Bots', alpha=0.7, zorder=2)
    
    time_text = ax.text(0.02, 0.95, '', transform=ax.transAxes, color='white', 
                        fontsize=10, bbox=dict(facecolor='black', alpha=0.6))
    
    ax.legend(loc="upper right")
    unique_times = match_df['ts'].unique()
    
    def update(frame_idx):
        current_time = unique_times[frame_idx]
        current_state = match_df[match_df['ts'] <= current_time]
        
        latest_positions = current_state.drop_duplicates(subset=['user_id'], keep='last')
        
        # Safely split humans and bots now that we know user_id is definitely a string
        humans = latest_positions[
            ~latest_positions['user_id'].astype(str).str.isdigit()
        ]

        bots = latest_positions[
            latest_positions['user_id'].astype(str).str.isdigit()
        ]
        human_scatter.set_offsets(humans[['pixel_x', 'pixel_y']].values if not humans.empty else np.empty((0, 2)))
        bot_scatter.set_offsets(bots[['pixel_x', 'pixel_y']].values if not bots.empty else np.empty((0, 2)))
            
        time_text.set_text(f"Time: {pd.to_datetime(current_time).strftime('%H:%M:%S')}\n"
                           f"Humans Alive: {len(humans)}\nBots Alive: {len(bots)}")
        
        return human_scatter, bot_scatter, time_text

    ani = animation.FuncAnimation(fig, update, frames=len(unique_times), 
                                  interval=20, blit=True, repeat=False)
    
    plt.tight_layout()
    plt.show() 




def find_highest_player_match_any_map(folder_path):
    """
    Searches the entire directory and returns:
        match_id,
        map_id,
        unique_player_count

    for the match having the highest number of unique players.
    """

    print("Searching all matches for highest player count...")

    match_players = {}
    match_maps = {}

    for filename in os.listdir(folder_path):
        if not filename.endswith(".nakama-0"):
            continue

        filepath = os.path.join(folder_path, filename)

        try:
            table = pq.read_table(
                filepath,
                columns=["match_id", "map_id", "user_id"]
            )

            df = table.to_pandas()

            if df.empty:
                continue

            match_id = str(df["match_id"].iloc[0]).replace(".nakama-0", "")
            map_id = str(df["map_id"].iloc[0])

            if match_id not in match_players:
                match_players[match_id] = set()
                match_maps[match_id] = map_id

            match_players[match_id].update(
                df["user_id"].astype(str).unique()
            )

        except Exception:
            continue

    if not match_players:
        print("No matches found.")
        return None, None, 0

    best_match_id = max(
        match_players,
        key=lambda m: len(match_players[m])
    )

    best_map = match_maps[best_match_id]
    player_count = len(match_players[best_match_id])

    print(
        f"Highest player match: {best_match_id}\n"
        f"Map: {best_map}\n"
        f"Players: {player_count}"
    )

    return best_match_id, best_map, player_count



    def get_dates(self) -> list[str]:
            """Calls DataEngine to find folders, passing its own instance (self)"""
            return DataEngine.get_available_dates(self)

    def get_matches_for_date(self, date_str: str) -> dict:
        """Calls DataEngine to find matches, passing its own instance (self)"""
        return DataEngine.get_available_matches_per_date(self, date_str)

    def get_match_heatmap_payload(self, match_df: pd.DataFrame, map_id: str) -> dict:
        """Calls DataEngine to extract grid intensities, passing its own instance (self)"""
        return DataEngine.get_heatmaps(self, match_df, map_id)


# --- EXECUTION ---
if __name__ == "__main__":
    
    # TARGET_FOLDER = "/home/eaglex/eagleSpace/GAME_DEV/eagle_game_analytics/backend/data/player_data/February_10" 
    # TARGET_FOLDER = "/home/eaglex/eagleSpace/GAME_DEV/eagle_game_analytics/backend/data/player_data/February_11" 
    # TARGET_FOLDER = "/home/eaglex/eagleSpace/GAME_DEV/eagle_game_analytics/backend/data/player_data/February_12" 
    # TARGET_FOLDER = "/home/eaglex/eagleSpace/GAME_DEV/eagle_game_analytics/backend/data/player_data/February_13" 
    TARGET_FOLDER = "/home/eaglex/eagleSpace/GAME_DEV/eagle_game_analytics/backend/data/player_data/February_14" 
    MAP_FOLDER = "/home/eaglex/eagleSpace/GAME_DEV/eagle_game_analytics/backend/data/player_data" 
    TARGET_MAP = ""
    # TARGET_MAP = "GrandRift"
    # TARGET_MAP = "GrandRift"
    
    USE_HIGHEST_PLAYER_MATCH = True

    if USE_HIGHEST_PLAYER_MATCH:

        match_to_play, TARGET_MAP, player_count = (
            find_highest_player_match_any_map(
                TARGET_FOLDER
            )
        )
        print(f"Auto-selected map: {TARGET_MAP}")

    else:

        match_to_play = find_match_by_map(
            TARGET_FOLDER,
            TARGET_MAP
        )

    if match_to_play:
        match_data = load_specific_match(
            TARGET_FOLDER,
            match_to_play
        )

        play_match(match_data)