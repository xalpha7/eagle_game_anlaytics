import pandas as pd
from typing import List, Optional
from fastapi import APIRouter, Depends, HTTPException, Request, Query
from fastapi.responses import Response

from models.response_models import MatchResponse, MatchStatsResponse
from services.match_service import MatchService
from services.stats_service import StatsService
from services.heatmap_service import HeatmapService, HeatmapType

router = APIRouter()

# Dependency Injection to supply DataFrame globally
def get_dataframe(request: Request) -> pd.DataFrame:
    try:
        df = request.app.state.df
        if df is None or df.empty:
            raise HTTPException(status_code=500, detail="Data unavailable")
        return df
    except AttributeError:
        raise HTTPException(status_code=500, detail="State not initialized")

@router.get("/maps", response_model=List[str])
def get_maps(df: pd.DataFrame = Depends(get_dataframe)):
    return MatchService(df).list_maps()

@router.get("/dates", response_model=List[str])
def get_dates(df: pd.DataFrame = Depends(get_dataframe)):
    return MatchService(df).list_dates()

@router.get("/matches", response_model=List[str])
def get_matches(
    map_id: Optional[str] = Query(None, description="Filter by Map"),
    date: Optional[str] = Query(None, description="Filter by Date"),
    df: pd.DataFrame = Depends(get_dataframe)
):
    return MatchService(df).list_matches(map_id=map_id, date=date)

@router.get("/matches/{match_id}", response_model=MatchResponse)
def get_match_details(match_id: str, df: pd.DataFrame = Depends(get_dataframe)):
    match = MatchService(df).get_match(match_id)
    if not match:
        raise HTTPException(status_code=404, detail="Match not found")
    return match

@router.get("/matches/{match_id}/stats", response_model=MatchStatsResponse)
def get_match_stats(match_id: str, df: pd.DataFrame = Depends(get_dataframe)):
    stats = StatsService(df).get_match_stats(match_id)
    if not stats:
        raise HTTPException(status_code=404, detail="Match not found")
    return stats

@router.get("/heatmap", responses={200: {"content": {"image/png": {}}}})
def get_heatmap(
    map_id: str = Query(..., description="Map Identifier"),
    heatmap_type: HeatmapType = Query(..., description="Type of heatmap"),
    df: pd.DataFrame = Depends(get_dataframe)
):
    valid_maps = MatchService(df).list_maps()
    if map_id not in valid_maps:
        raise HTTPException(status_code=400, detail="Invalid map_id")
        
    heatmap_bytes = HeatmapService(df).generate_heatmap(map_id, heatmap_type)
    
    return Response(content=heatmap_bytes, media_type="image/png")