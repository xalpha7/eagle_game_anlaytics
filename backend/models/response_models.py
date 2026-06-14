from typing import List
from pydantic import BaseModel
from models.event_models import EventModel

class MatchResponse(BaseModel):
    """Payload returning all chronological events for a specific match."""
    match_id: str
    map_id: str
    events: List[EventModel]

class MatchStatsResponse(BaseModel):
    """Aggregated match analytics for a single gameplay session."""
    match_id: str
    map_id: str
    total_humans: int
    total_bots: int
    kills: int
    deaths: int
    loots: int
    storm_deaths: int
    duration_seconds: int