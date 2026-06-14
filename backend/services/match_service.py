import pandas as pd
from typing import List, Optional, Dict, Any
from models.response_models import MatchResponse

class MatchService:
    """Service for querying and formatting base match data."""
    
    def __init__(self, df: pd.DataFrame):
        self.df = df

    def list_maps(self) -> List[str]:
        """Returns a list of all distinct maps in the dataset."""
        return sorted(self.df['map_id'].dropna().unique().tolist())

    def list_dates(self) -> List[str]:
        """Returns a list of all distinct dates (folders) in the dataset."""
        if 'date' not in self.df.columns:
            return []
        return sorted(self.df['date'].dropna().unique().tolist())

    def list_matches(self, map_id: Optional[str] = None, date: Optional[str] = None) -> List[str]:
        """Filters matches based on optional map and date inputs."""
        filtered_df = self.df
        
        if map_id:
            filtered_df = filtered_df[filtered_df['map_id'] == map_id]
        if date and 'date' in filtered_df.columns:
            filtered_df = filtered_df[filtered_df['date'] == date]
            
        return filtered_df['match_id'].dropna().unique().tolist()

    def get_match(self, match_id: str) -> Optional[MatchResponse]:
        """Returns a fully formatted match payload, ordered by timestamp."""
        match_df = self.df[self.df['match_id'] == match_id]
        
        if match_df.empty:
            return None
            
        # Data is pre-sorted in ParquetLoader, but enforcing order here is robust
        match_df = match_df.sort_values(by='ts')
        
        map_id = match_df['map_id'].iloc[0]
        
        # Drop internal columns safely before conversion
        out_df = match_df.drop(columns=['date'], errors='ignore')
        
        events = out_df.to_dict(orient='records')
        
        return MatchResponse(
            match_id=match_id,
            map_id=map_id,
            events=events
        )