from pydantic import BaseModel

class EventModel(BaseModel):
    """
    Represents a single player event during a match.
    All coordinate conversions and logic checks are already applied.
    """
    user_id: str
    match_id: str
    map_id: str
    x: float
    y: float
    z: float
    pixel_x: float
    pixel_y: float
    ts: int
    event: str
    is_bot: bool