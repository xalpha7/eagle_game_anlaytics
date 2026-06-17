import json
from fastapi import FastAPI, WebSocket, WebSocketDisconnect
import uvicorn
from data_engine import DataEngine
from heatmaps import generate_heatmap_b64

from engine import GameEngine

app = FastAPI(title="EAGLE GAME Analytics Server")
engine = DataEngine()

BASE_PATH = "/home/eaglex/eagleSpace/GAME_DEV/eagle_game_analytics/backend/data/player_data"
gameplay_engine = GameEngine(base_data_path=BASE_PATH)

@app.websocket("/ws")
async def websocket_endpoint(websocket: WebSocket) -> None:
    await websocket.accept()
    try:
        while True:
            message = await websocket.receive_text()
            payload = json.loads(message)
            action = payload.get("action")
            # --- FEATURE 1: Initialization Routing Parameters ---
            if action == "get_init_data":
                available_dates = gameplay_engine.get_dates()
                await websocket.send_json({
                    "type": "init_data",
                    "data": available_dates
                })
               
            elif action == "heatmap_data":
                data_payload = payload.get("data", {})
                match_date = data_payload.get("date")          # e.g. "February_14"
                target_match_id = data_payload.get("match_id") # e.g. "7a8b9c..."

                if not match_date or not target_match_id:
                    await websocket.send_json({
                        "type": "error",
                        "message": "Missing required 'date' or 'match_id' properties inside action data context."
                    })
                    continue

                # 1. Pull the data frames together via data algorithm
                match_df = gameplay_engine.load_match_data(match_date, target_match_id)
                
                if match_df.empty:
                    await websocket.send_json({
                        "type": "heatmap_response",
                        "data": {"error": f"No telemetry files found for Match ID {target_match_id}"}
                    })
                    continue

                # 2. Compute binned spatial metrics matrices
                heatmap_results = gameplay_engine.get_heatmap_payload(match_df)

                # 3. Stream structural payload back over open communication channel
                await websocket.send_json({
                    "type": "heatmap_response",
                    "data": heatmap_results
                })
            elif action == "get_matches_per_date":
                match_date = payload.get("data", "February_14")
                result_data = gameplay_engine.get_available_matches_per_date(match_date)
                # gameplay_engine.visualize_frontend_data(result_data)
                await websocket.send_json({
                    "type": "game_play",
                    "data": result_data
                })
            elif action == "get_match_playback":
                match_date = payload.get("data", "February_14")
                result_data = gameplay_engine.run_gameplay(
                    date=match_date, 
                    highest_player_match=True
                )
                # gameplay_engine.visualize_frontend_data(result_data)
                await websocket.send_json({
                    "type": "game_play",
                    "data": result_data
                })
    

    except WebSocketDisconnect:
        print("Frontend client socket terminated cleanly.")
    except Exception as e:
        print(f"Error executing communication framing channel: {e}")

if __name__ == "__main__":
    uvicorn.run(app, host="0.0.0.0", port=8765, log_level="info")