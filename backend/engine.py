import os
import pandas as pd
import pyarrow.parquet as pq
import numpy as np

# CRITICAL: Matplotlib backend must be declared before importing pyplot 
import matplotlib
matplotlib.use('TkAgg') 
import matplotlib.pyplot as plt
import matplotlib.animation as animation
import matplotlib.image as mpimg


class GameEngine:
    """
    A service class to extract and format match telemetry data for frontend consumption,
    equipped with a local playback rendering engine for verification.
    """
    
    MAP_CONFIGS = {
        "AmbroseValley": {"scale": 900,  "origin_x": -370, "origin_z": -473, "img": "minimaps/AmbroseValley_Minimap.png"},
        "GrandRift":     {"scale": 581,  "origin_x": -290, "origin_z": -290, "img": "minimaps/GrandRift_Minimap.png"},
        "Lockdown":      {"scale": 1000, "origin_x": -500, "origin_z": -500, "img": "minimaps/Lockdown_Minimap.jpg"}
    }

    def __init__(self, base_data_path: str):
        """Initializes the generator with the root directory of the player data."""
        self.base_data_path = base_data_path

    def run_gameplay(self, date: str, target_map: str = None, match_id: str = None, highest_player_match: bool = False) -> dict:
        folder_path = os.path.join(self.base_data_path, date)
        if not os.path.exists(folder_path):
            return {"error": f"Directory '{folder_path}' not found."}

        target_match_id = match_id
        selected_map = target_map
        if not target_match_id:
            if highest_player_match:
                target_match_id, selected_map, _ = self._find_highest_player_match(folder_path)
            elif target_map:
                target_match_id = self._find_match_by_map(folder_path, target_map)
            else:
                return {"error": "Must provide match_id, target_map, or set highest_player_match=True"}

        if not target_match_id:
            return {"error": "Could not find a valid match matching the criteria."}

        match_df = self._load_specific_match(folder_path, target_match_id)
        if match_df.empty:
            return {"error": "Match data is empty or failed to load."}
        if not selected_map and 'map_id' in match_df.columns:
            selected_map = str(match_df['map_id'].iloc[0])
        return self._format_for_frontend(match_df, target_match_id, selected_map)

    def visualize_frontend_data(self, result_data: dict):
        """
        Plugin independent playback window. Accepts the generated 'result_data' 
        payload and reconstructs the Matplotlib Tkinter loop.
        """
        if not result_data or "error" in result_data:
            print("Visualization Error: Invalid or error payload provided.")
            return

        metadata = result_data["metadata"]
        timeline = result_data["timeline"]
        map_id = metadata["map_id"]
        config = metadata["map_config"]

        print(f"Reconstructing {metadata['total_frames']} frames for local playback...")
        
        # 1. Pre-process the timeline updates into continuous positional state snapshots
        frame_snapshots = []
        current_state = {}

        for frame in timeline:
            for item in frame["events"]:
                # Track/Overwrite the latest position markers per player ID
                current_state[item["user_id"]] = item
            # Save a decoupled copy of active player positions for this frame index
            frame_snapshots.append(list(current_state.values()))

        # 2. Build the Plotting Window
        fig, ax = plt.subplots(figsize=(8, 8))
        
        try:
            img_path = os.path.join(self.base_data_path, config["img"])
            img = mpimg.imread(img_path)
            ax.imshow(img, extent=[0, 1024, 1024, 0])
        except Exception as e:
            print(f"Warning: Minimap image not found at '{img_path}'. Fallback to blank canvas.")
            ax.set_xlim(0, 1024)
            ax.set_ylim(1024, 0)

        ax.set_title(f"Frontend Data Verification Engine | Map: {map_id}\nMatch: {metadata['match_id'][:13]}...")
        ax.axis('off')

        # Marker settings matching original design
        human_scatter = ax.scatter([], [], c='#00ff00', s=45, label='Humans', edgecolors='black', zorder=3)
        bot_scatter = ax.scatter([], [], c='#ff0000', s=15, label='Bots', alpha=0.7, zorder=2)
        
        time_text = ax.text(0.02, 0.95, '', transform=ax.transAxes, color='white', 
                            fontsize=10, bbox=dict(facecolor='black', alpha=0.6))
        ax.legend(loc="upper right")

        # 3. Animation Update Handler Loop
        def update(frame_idx):
            snapshot = frame_snapshots[frame_idx]
            timestamp_str = timeline[frame_idx]["timestamp"]

            humans_x, humans_y = [], []
            bots_x, bots_y = [], []

            for p in snapshot:
                if p["is_bot"]:
                    bots_x.append(p["pixel_x"])
                    bots_y.append(p["pixel_y"])
                else:
                    humans_x.append(p["pixel_x"])
                    humans_y.append(p["pixel_y"])

            # Vectorize matching sets
            human_offsets = np.column_stack((humans_x, humans_y)) if humans_x else np.empty((0, 2))
            bot_offsets = np.column_stack((bots_x, bots_y)) if bots_x else np.empty((0, 2))

            human_scatter.set_offsets(human_offsets)
            bot_scatter.set_offsets(bot_offsets)

            try:
                formatted_time = pd.to_datetime(timestamp_str).strftime('%H:%M:%S')
            except Exception:
                formatted_time = timestamp_str

            time_text.set_text(f"Time: {formatted_time}\n"
                               f"Humans Active: {len(humans_x)}\nBots Active: {len(bots_x)}")

            return human_scatter, bot_scatter, time_text

        ani = animation.FuncAnimation(fig, update, frames=len(timeline), 
                                      interval=20, blit=True, repeat=False)
        plt.tight_layout()
        plt.show()

    # --- INTERNAL UTILITY METHODS ---

    def _find_match_by_map(self, folder_path: str, target_map: str) -> str:
        for filename in os.listdir(folder_path):
            if not filename.endswith('.nakama-0'):
                continue
            filepath = os.path.join(folder_path, filename)
            try:
                table = pq.read_table(filepath, columns=['match_id', 'map_id'])
                df = table.to_pandas()
                if not df.empty and df['map_id'].iloc[0] == target_map:
                    return str(df['match_id'].iloc[0]).replace('.nakama-0', '')
            except Exception:
                continue
        return None

    def _find_highest_player_match(self, folder_path: str):
        match_players, match_maps = {}, {}
        for filename in os.listdir(folder_path):
            if not filename.endswith(".nakama-0"):
                continue
            filepath = os.path.join(folder_path, filename)
            try:
                table = pq.read_table(filepath, columns=["match_id", "map_id", "user_id"])
                df = table.to_pandas()
                if df.empty:
                    continue
                m_id = str(df["match_id"].iloc[0]).replace(".nakama-0", "")
                if m_id not in match_players:
                    match_players[m_id] = set()
                    match_maps[m_id] = str(df["map_id"].iloc[0])
                match_players[m_id].update(df["user_id"].astype(str).unique())
            except Exception:
                continue
        if not match_players:
            return None, None, 0
        best_match_id = max(match_players, key=lambda m: len(match_players[m]))
        return best_match_id, match_maps[best_match_id], len(match_players[best_match_id])

    def _load_specific_match(self, folder_path: str, target_match_id: str) -> pd.DataFrame:
        frames = []
        for filename in os.listdir(folder_path):
            if not filename.endswith('.nakama-0'):
                continue
            parts = filename.split('_')
            if len(parts) >= 2 and parts[-1].replace('.nakama-0', '') == target_match_id:
                filepath = os.path.join(folder_path, filename)
                try:
                    table = pq.read_table(filepath)
                    frames.append(table.to_pandas())
                except Exception:
                    continue
        if not frames:
            return pd.DataFrame()
        match_df = pd.concat(frames, ignore_index=True)
        if 'event' in match_df.columns:
            match_df['event'] = match_df['event'].apply(lambda x: x.decode('utf-8') if isinstance(x, bytes) else x)
        match_df['user_id'] = match_df['user_id'].astype(str)
        return match_df

    def _convert_to_minimap_coords(self, df: pd.DataFrame, map_id: str) -> pd.DataFrame:
        config = self.MAP_CONFIGS.get(map_id)
        if not config:
            df['pixel_x'], df['pixel_y'] = df.get('x', 0), df.get('z', 0)
            return df
        df['pixel_x'] = ((df['x'] - config["origin_x"]) / config["scale"]) * 1024
        df['pixel_y'] = (1 - ((df['z'] - config["origin_z"]) / config["scale"])) * 1024
        return df

    def _format_for_frontend(self, match_df: pd.DataFrame, match_id: str, map_id: str) -> dict:
        match_df = match_df.sort_values(by='ts').reset_index(drop=True)
        match_df = self._convert_to_minimap_coords(match_df, map_id)
        match_df['is_bot'] = match_df['user_id'].str.isdigit()
        match_df['ts_str'] = match_df['ts'].astype(str)

        unique_users = match_df[['user_id', 'is_bot']].drop_duplicates()
        total_bots = unique_users['is_bot'].sum()
        total_humans = len(unique_users) - total_bots

        timeline = []
        columns_to_keep = ['user_id', 'is_bot', 'pixel_x', 'pixel_y', 'event']
        
        for ts, group in match_df.groupby('ts_str'):
            updates = group[columns_to_keep].dropna(subset=['pixel_x', 'pixel_y']).to_dict(orient='records')
            timeline.append({"timestamp": ts, "events": updates})

        return {
            "metadata": {
                "match_id": match_id,
                "map_id": map_id,
                "map_config": self.MAP_CONFIGS.get(map_id, {}),
                "total_humans": int(total_humans),
                "total_bots": int(total_bots),
                "total_frames": len(timeline)
            },
            "timeline": timeline
        }


    def get_dates(self) -> list[str]:
        # Assuming get_available_dates exists in your DataEngine
        return sorted([d for d in os.listdir(self.base_data_path) if os.path.isdir(os.path.join(self.base_data_path, d))])

    def get_matches_for_date(self, date_str: str) -> dict:
        """Calls DataEngine to find matches, passing its own instance (self)"""
        return DataEngine.get_available_matches_per_date(self, date_str)


    def load_match_data(self, date_str: str, match_id: str) -> pd.DataFrame:
        """Delegates file reading algorithm out to the DataEngine execution layer"""
        return DataEngine.load_match_dataframe(self, date_str, match_id)

    def get_heatmap_payload(self, match_df: pd.DataFrame) -> dict:
        """Delegates spatial matrix compilation processing to the DataEngine layer"""
        return DataEngine.get_heatmaps(self, match_df)
# --- EXECUTION CHECK ---
if __name__ == "__main__":
    BASE_PATH = "/home/eaglex/eagleSpace/GAME_DEV/eagle_game_analytics/backend/data/player_data"
    
    # 1. Initialize engine
    engine = GameplayDataGenerator(base_data_path=BASE_PATH)
    
    # 2. Extract structured frontend data dictionary
    frontend_json_payload = engine.run_gameplay(
        date="February_14", 
        highest_player_match=True
    )
    
    # 3. Pass the generated dict cleanly to display your Tkinter visualization window
    engine.visualize_frontend_data(frontend_json_payload)