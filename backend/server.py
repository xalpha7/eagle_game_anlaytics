import json
from fastapi import FastAPI, WebSocket, WebSocketDisconnect
import uvicorn
from data_engine import DataEngine
from heatmaps import generate_heatmap_b64

app = FastAPI(title="EAGLE GAME Analytics Server")
engine = DataEngine()

@app.websocket("/ws")
async def websocket_endpoint(websocket: WebSocket) -> None:
    await websocket.accept()
    try:
        while True:
            message = await websocket.receive_text()
            payload = json.loads(message)
            action = payload.get("action")
            date_str = payload.get("date")
            map_filter = payload.get("map_id")       # Optional filter criteria
            match_filter = payload.get("match_id")   # Optional filter criteria
            
            # --- FEATURE 1: Initialization Routing Parameters ---
            if action == "get_init_data":
                if date_str:
                    engine.load_date_data(date_str)
                
                await websocket.send_json({
                    "type": "init_data",
                    "available_dates": engine.get_available_dates(),
                    "requested_date": date_str,
                    "maps_played": engine.get_maps_played()
                })
            
            # --- FEATURE 2: High Level Summary & Data Filtering Grid Streams ---
            elif action == "fetch_date_data":
                engine.load_date_data(date_str)
                
                # Fetch match summary rows (honors the map filter if active)
                match_stats = engine.get_match_stats(filter_map=map_filter)
                await websocket.send_json({
                    "type": "match_stats",
                    "data": match_stats
                })
                
                # Generate and stream heatmaps based on selected filters
                maps_to_render = [map_filter] if map_filter else engine.get_maps_played()
                for map_id in maps_to_render:
                    map_df = engine.get_filtered_heatmap_data(map_id, match_id=match_filter)
                    if map_df.empty:
                        continue
                    
                    # Compute specialized layer heatmaps
                    traffic_b64 = generate_heatmap_b64(map_df['pixel_x'], map_df['pixel_y'])
                    
                    kills_df = map_df[map_df['classified_event'].isin(['Kill', 'BotKill'])]
                    kills_b64 = generate_heatmap_b64(kills_df['pixel_x'], kills_df['pixel_y'])
                    
                    deaths_df = map_df[map_df['classified_event'].isin(['Killed', 'BotKilled', 'KilledByStorm'])]
                    deaths_b64 = generate_heatmap_b64(deaths_df['pixel_x'], deaths_df['pixel_y'])
                    
                    loot_df = map_df[map_df['classified_event'] == 'Loot']
                    loot_b64 = generate_heatmap_b64(loot_df['pixel_x'], loot_df['pixel_y'])
                    
                    await websocket.send_json({
                        "type": "heatmap_data",
                        "map_id": map_id,
                        "scope": "match" if match_filter else "global_day",
                        "heatmaps": {
                            "traffic": traffic_b64,
                            "kills": kills_b64,
                            "deaths": deaths_b64,
                            "loot": loot_b64
                        }
                    })

            # --- FEATURE 3: Timeline Playback Vector Stream Engine ---
            elif action == "fetch_match_playback":
                # Isolate a single match context explicitly 
                if match_filter:
                    timeline_payload = engine.get_match_timeline(match_filter)
                    await websocket.send_json({
                        "type": "match_playback_timeline",
                        "data": timeline_payload
                    })

    except WebSocketDisconnect:
        print("Frontend client socket terminated cleanly.")
    except Exception as e:
        print(f"Error executing communication framing channel: {e}")

if __name__ == "__main__":
    uvicorn.run(app, host="0.0.0.0", port=8765, log_level="info")