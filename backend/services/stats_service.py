import pandas as pd
from typing import Optional
from models.response_models import MatchStatsResponse

class StatsService:
    """Service to aggregate metrics and count analytics for matches."""
    
    def __init__(self, df: pd.DataFrame):
        self.df = df

    def get_match_stats(self, match_id: str) -> Optional[MatchStatsResponse]:
        """Calculates specific stats based on rules applied to the dataframe."""
        match_df = self.df[self.df['match_id'] == match_id]
        
        if match_df.empty:
            return None
            
        map_id = str(match_df['map_id'].iloc[0])
        
        # Duration Calculation
        min_ts = int(match_df['ts'].min())
        max_ts = int(match_df['ts'].max())
        duration_seconds = max_ts - min_ts if max_ts > min_ts else 0

        # Distinct User Counting
        unique_users = match_df[['user_id', 'is_bot']].drop_duplicates()
        total_humans = int((~unique_users['is_bot']).sum())
        total_bots = int(unique_users['is_bot'].sum())

        # Event Type Aggregations
        event_counts = match_df['event'].value_counts()
        
        kills = int(event_counts.get('Kill', 0) + event_counts.get('BotKill', 0))
        deaths = int(event_counts.get('Killed', 0) + event_counts.get('BotKilled', 0))
        loots = int(event_counts.get('Loot', 0))
        storm_deaths = int(event_counts.get('KilledByStorm', 0))

        return MatchStatsResponse(
            match_id=match_id,
            map_id=map_id,
            total_humans=total_humans,
            total_bots=total_bots,
            kills=kills,
            deaths=deaths,
            loots=loots,
            storm_deaths=storm_deaths,
            duration_seconds=duration_seconds
        )