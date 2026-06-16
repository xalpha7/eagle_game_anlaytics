import os
import glob
import pandas as pd
import numpy as np

MAP_CONFIGS = {
    "AmbroseValley": {"scale": 900.0, "origin_x": -370.0, "origin_z": -473.0},
    "GrandRift": {"scale": 581.0, "origin_x": -290.0, "origin_z": -290.0},
    "Lockdown": {"scale": 1000.0, "origin_x": -500.0, "origin_z": -500.0}
}

class DataEngine:
    def __init__(self, data_dir: str = "data/player_data"):
        self.data_dir = data_dir
        self.df = pd.DataFrame()

    def load_date_data(self, date_str: str) -> None:
        """
        Resets internal DataFrame memory completely and reads parquet data
        directly from the target date directory.
        """
        self.df = pd.DataFrame()
        if not date_str:
            return

        folder_path = os.path.join(self.data_dir, date_str)
        if not os.path.exists(folder_path):
            print(f"Data directory path not found: {folder_path}")
            return

        try:
            self.df = pd.read_parquet(folder_path, engine='pyarrow')
            self.df['date'] = date_str
            self._process_dataframe()
        except Exception as e:
            print(f"Directory read failed, falling back to explicit file pattern: {e}")
            files = glob.glob(os.path.join(folder_path, "*"))
            if files:
                all_dfs = [pd.read_parquet(f) for f in files]
                self.df = pd.concat(all_dfs, ignore_index=True)
                self.df['date'] = date_str
                self._process_dataframe()

    def _process_dataframe(self) -> None:
        if self.df.empty:
            return

        # 1. Distinguish between human players (UUIDs) and bots (numeric strings)
        self.df['is_bot'] = ~self.df['user_id'].astype(str).str.contains('-', na=False)

        # 2. Extract relative match-seconds timeline tracking indices
        if pd.api.types.is_datetime64_any_dtype(self.df['ts']):
            self.df['ts_seconds'] = self.df['ts'].astype('int64') // 10**9
        else:
            self.df['ts_seconds'] = self.df['ts'].astype(np.int64)

        # 3. World-to-Minimap coordinate space mapping configuration (1024x1024 pixels)
        self.df['pixel_x'] = 0.0
        self.df['pixel_y'] = 0.0
        for map_id, config in MAP_CONFIGS.items():
            mask = self.df['map_id'] == map_id
            if not mask.any():
                continue
            u = (self.df.loc[mask, 'x'] - config['origin_x']) / config['scale']
            v = (self.df.loc[mask, 'z'] - config['origin_z']) / config['scale']
            self.df.loc[mask, 'pixel_x'] = u * 1024.0
            self.df.loc[mask, 'pixel_y'] = (1.0 - v) * 1024.0

        # 4. Binary byte array parsing for string matching safely
        def decode_bytes(val) -> str:
            if isinstance(val, bytes):
                return val.decode('utf-8')
            return str(val)
            
        event_str = self.df['event'].apply(decode_bytes)
        self.df['classified_event'] = event_str

        # Reclassify combat metrics to distinguish bots vs humans visually
        self.df.loc[(event_str == 'Kill') & self.df['is_bot'], 'classified_event'] = 'BotKill'
        self.df.loc[(event_str == 'Killed') & self.df['is_bot'], 'classified_event'] = 'BotKilled'

    def get_available_dates(self) -> list[str]:
        if not os.path.exists(self.data_dir):
            return []
        return sorted([d for d in os.listdir(self.data_dir) if os.path.isdir(os.path.join(self.data_dir, d))])

    def get_maps_played(self) -> list[str]:
        if self.df.empty:
            return []
        return sorted(self.df['map_id'].dropna().unique().tolist())

    def get_match_stats(self, filter_map: str = None) -> list[dict]:
        """
        Returns basic summary metrics for matches on the loaded date,
        optionally filtered by a selected map.
        """
        if self.df.empty:
            return []

        target_df = self.df if not filter_map else self.df[self.df['map_id'] == filter_map]
        stats_list = []
        
        for match_id, group in target_df.groupby('match_id'):
            map_id = group['map_id'].iloc[0] if not group['map_id'].empty else "Unknown"
            total_humans = int(group[~group['is_bot']]['user_id'].nunique())
            total_bots = int(group[group['is_bot']]['user_id'].nunique())
            
            events = group['classified_event']
            kills = int(events.isin(['Kill', 'BotKill']).sum())
            deaths = int(events.isin(['Killed', 'BotKilled', 'KilledByStorm']).sum())
            loots = int((events == 'Loot').sum())
            storm_deaths = int((events == 'KilledByStorm').sum())
            
            duration_seconds = int(group['ts_seconds'].max() - group['ts_seconds'].min())
            
            stats_list.append({
                "match_id": str(match_id),
                "map_id": str(map_id),
                "total_humans": total_humans,
                "total_bots": total_bots,
                "kills": kills,
                "deaths": deaths,
                "loots": loots,
                "storm_deaths": storm_deaths,
                "duration_seconds": max(0, duration_seconds)
            })
        return stats_list

    def get_match_timeline(self, match_id: str) -> dict:
        """
        Extracts highly focused chronology paths and combat event indicators
        for a single match to power the frontend playback timeline smoothly.
        """
        match_df = self.df[self.df['match_id'] == match_id]
        if match_df.empty:
            return {"match_id": match_id, "start_ts": 0, "end_ts": 0, "events": []}

        sorted_df = match_df.sort_values(by='ts_seconds')
        start_ts = int(sorted_df['ts_seconds'].min())
        end_ts = int(sorted_df['ts_seconds'].max())
        
        events_list = []
        for _, row in sorted_df.iterrows():
            events_list.append({
                "user_id": str(row['user_id']),
                "is_bot": bool(row['is_bot']),
                "event_type": str(row['classified_event']),
                "pixel_x": float(row['pixel_x']),
                "pixel_y": float(row['pixel_y']),
                "timestamp_seconds": int(row['ts_seconds'])
            })

        return {
            "match_id": match_id,
            "map_id": str(sorted_df['map_id'].iloc[0]),
            "start_ts": start_ts,
            "end_ts": end_ts,
            "events": events_list
        }

    def get_filtered_heatmap_data(self, map_id: str, match_id: str = None) -> pd.DataFrame:
        """Filter helper for targeted heatmap overlays."""
        if self.df.empty:
            return pd.DataFrame()
        mask = self.df['map_id'] == map_id
        if match_id:
            mask = mask & (self.df['match_id'] == match_id)
        return self.df[mask]