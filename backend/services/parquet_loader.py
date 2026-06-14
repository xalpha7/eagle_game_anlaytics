import logging
import pandas as pd
from pathlib import Path
from config.settings import PLAYER_DATA_DIR
from config.map_config import MAP_CONFIG

logger = logging.getLogger(__name__)

class ParquetLoader:
    """
    Loads, cleans, and structures all parquet dataset files into memory.
    It performs one-time initialization for bot detection, event decoding,
    and coordinate mapping to prevent runtime overhead.
    """
    
    def __init__(self):
        print(f"data path >>>>>>>>{PLAYER_DATA_DIR}")
        self._df: pd.DataFrame = pd.DataFrame()

    def load_data(self) -> None:
        """Reads all parquet files, processes rules, and loads them into memory."""
        logger.info(f"Scanning for parquet files in {PLAYER_DATA_DIR}...")
        
        if not PLAYER_DATA_DIR.exists():
            raise FileNotFoundError(f"Data directory not found: {PLAYER_DATA_DIR}")

        file_paths = list(PLAYER_DATA_DIR.rglob("*.nakama-0"))
        
        if not file_paths:
            logger.warning("No parquet files found in the dataset directory.")
            return

        dataframes = []
        for file in file_paths:
            try:
                # Load individual file
                temp_df = pd.read_parquet(file)
                # Extract date from parent folder (e.g., February_10)
                temp_df['date'] = file.parent.name
                dataframes.append(temp_df)
            except Exception as e:
                logger.error(f"Error reading parquet file {file.name}: {e}")
                
        if not dataframes:
            raise ValueError("No valid data could be loaded from the parquet files.")

        # Concatenate all files into a single dataframe
        self._df = pd.concat(dataframes, ignore_index=True)
        
        # 1. Decode event bytes
        if self._df['event'].apply(type).eq(bytes).any():
            self._df['event'] = self._df['event'].str.decode('utf-8')
            
        # 2. Determine bot status (Humans have '-' in user_id)
        self._df['is_bot'] = ~self._df['user_id'].str.contains("-", na=False)
        
        # 3. Cast timestamp to integer for consistency
        self._df['ts'] = self._df['ts'].astype(int)

        # 4. Vectorized world to pixel coordinate conversion
        self._apply_coordinate_conversion()
        
        # Sort by timestamp globally for correct chronological ordering
        self._df.sort_values(by=['match_id', 'ts'], inplace=True)
        logger.info(f"Successfully loaded {len(self._df)} events into memory.")

    def _apply_coordinate_conversion(self) -> None:
        """Applies vectorized math to calculate pixel_x and pixel_y for all rows."""
        # Map constants to DataFrame columns
        self._df['scale'] = self._df['map_id'].map({k: v['scale'] for k, v in MAP_CONFIG.items()})
        self._df['origin_x'] = self._df['map_id'].map({k: v['origin_x'] for k, v in MAP_CONFIG.items()})
        self._df['origin_z'] = self._df['map_id'].map({k: v['origin_z'] for k, v in MAP_CONFIG.items()})

        # Drop invalid maps
        self._df.dropna(subset=['scale', 'origin_x', 'origin_z'], inplace=True)

        # Apply math exactly as defined
        u = (self._df['x'] - self._df['origin_x']) / self._df['scale']
        v = (self._df['z'] - self._df['origin_z']) / self._df['scale']
        
        self._df['pixel_x'] = u * 1024.0
        self._df['pixel_y'] = (1.0 - v) * 1024.0
        
        # Clean up temporary columns to save memory
        self._df.drop(columns=['scale', 'origin_x', 'origin_z'], inplace=True)

    def get_dataframe(self) -> pd.DataFrame:
        """Returns the fully processed, read-only dataset view."""
        if self._df.empty:
            raise RuntimeError("Dataframe is empty. Call load_data() first.")
        return self._df