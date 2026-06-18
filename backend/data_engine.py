from engine import GameEngine
import os
import pandas as pd
import pyarrow.parquet as pq
import numpy as np

# CRITICAL: Matplotlib backend must be declared before importing pyplot 
import matplotlib
class DataEngine:
    """
    Stateless processing layer extending GameEngine logic.
    Generates structured analytics data optimized for frontend JSON consumption.
    """

    @staticmethod
    def get_available_dates(engine: GameEngine) -> list[str]:
        """Scans the base data directory and returns all unique date folders."""
        if not os.path.exists(engine.data_dir):
            print(f"Error: Base directory '{engine.data_dir}' not found.")
            return []
            
        return sorted([
            d for d in os.listdir(engine.data_dir) 
            if os.path.isdir(os.path.join(engine.data_dir, d))
        ])

    @staticmethod
    def get_available_matches_per_date(engine: GameEngine, date_str: str) -> dict:
        """Scans a date folder and returns available match IDs mapped to their map IDs."""
        folder_path = os.path.join(engine.data_dir, date_str)
        if not os.path.exists(folder_path):
            print(f"Error: Date folder '{folder_path}' not found.")
            return {}

        matches = {}
        for filename in os.listdir(folder_path):
            if not filename.endswith('.nakama-0'):
                continue
                
            filepath = os.path.join(folder_path, filename)
            try:
                table = pq.read_table(filepath, columns=['match_id', 'map_id'])
                df = table.to_pandas()
                
                if not df.empty:
                    match_id = str(df['match_id'].iloc[0]).replace('.nakama-0', '')
                    map_id = str(df['map_id'].iloc[0])
                    
                    if match_id not in matches:
                        matches[match_id] = map_id
            except Exception:
                continue
                
        return matches

    @staticmethod
    def load_match_dataframe(engine, date_str: str, target_match_id: str) -> pd.DataFrame:
        """
        Scans the data directory from the engine instance and builds 
        a single DataFrame for the given match ID.
        """
        folder_path = os.path.join(engine.base_data_path, date_str)
        if not os.path.exists(folder_path):
            print(f"Directory not found: {folder_path}")
            return pd.DataFrame()

        frames = []
        for filename in os.listdir(folder_path):
            if not filename.endswith('.nakama-0'):
                continue
                
            parts = filename.split('_')
            if len(parts) >= 2:
                file_match_id = parts[-1].replace('.nakama-0', '')
                
                if file_match_id == target_match_id:
                    filepath = os.path.join(folder_path, filename)
                    try:
                        table = pq.read_table(filepath)
                        frames.append(table.to_pandas())
                    except Exception as e:
                        print(f"Failed to read file {filename}: {e}")
                        continue
                        
        if not frames:
            return pd.DataFrame()
            
        return pd.concat(frames, ignore_index=True)

    @staticmethod
    def get_heatmaps(engine, match_df: pd.DataFrame, grid_bins: int = 50) -> dict:
        """Processes telemetry data into a JSON-friendly sparse matrix array."""
        if match_df.empty:
            return {"error": "Provided DataFrame is empty."}

        # Automatically extract map identity from dataset rows
        map_id = match_df['map_id'].iloc[0] if 'map_id' in match_df.columns else None
        config = engine.map_configs.get(map_id)
        if not config:
            return {"error": f"Map configuration for '{map_id}' missing."}

        # Coordinate conversion
        u = (match_df['x'] - config['origin_x']) / config['scale']
        v = (match_df['z'] - config['origin_z']) / config['scale']
        pixel_x = u * 1024.0
        pixel_y = (1.0 - v) * 1024.0

        if 'event' in match_df.columns:
            event_series = match_df['event'].apply(
                lambda x: x.decode('utf-8') if isinstance(x, bytes) else str(x)
            )
        else:
            event_series = pd.Series(['Unknown'] * len(match_df))

        kill_mask = event_series.isin(['Kill', 'BotKill'])
        death_mask = event_series.isin(['Killed', 'BotKilled', 'KilledByStorm'])

        def _generate_sparse_matrix(x_coords, y_coords) -> list[dict]:
            if len(x_coords) == 0:
                return []
            counts, x_edges, y_edges = np.histogram2d(
                x_coords, y_coords, bins=grid_bins, range=[[0, 1024], [0, 1024]]
            )
            x_centers = (x_edges[:-1] + x_edges[1:]) / 2
            y_centers = (y_edges[:-1] + y_edges[1:]) / 2
            
            sparse_points = []
            for i in range(grid_bins):
                for j in range(grid_bins):
                    intensity = int(counts[i, j])
                    if intensity > 0:
                        sparse_points.append({
                            "x": round(float(x_centers[i]), 1),
                            "y": round(float(y_centers[j]), 1),
                            "value": intensity
                        })
            return sparse_points

        return {
            "match_id": str(match_df['match_id'].iloc[0]).replace('.nakama-0', ''),
            "map_id": map_id,
            "data": {
                "traffic": _generate_sparse_matrix(pixel_x, pixel_y),
                "kills":   _generate_sparse_matrix(pixel_x[kill_mask], pixel_y[kill_mask]),
                "deaths":  _generate_sparse_matrix(pixel_x[death_mask], pixel_y[death_mask])
            }
        }