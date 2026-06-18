import json
import os
from pathlib import Path

from fastapi import FastAPI, WebSocket, WebSocketDisconnect

from engine import GameEngine

# from data_engine import DataEngine
# engine = DataEngine()

app = FastAPI(title="EAGLE GAME Analytics Server")
# Relative path that works locally and on Render
BASE_PATH = Path(__file__).resolve().parent / "data" / "player_data"
gameplay_engine = GameEngine(base_data_path=str(BASE_PATH))


@app.get("/")
async def health_check():
    return {"status": "running","service": "EAGLE GAME Analytics Server"}


@app.websocket("/ws")
async def websocket_endpoint(websocket: WebSocket) -> None:
    await websocket.accept()
    try:
        while True:
            message = await websocket.receive_text()
            payload = json.loads(message)
            action = payload.get("action")

            if action == "get_init_data":
                available_dates = gameplay_engine.get_dates()
                available_maps = gameplay_engine.get_all_map()
                await websocket.send_json({
                    "type": "init_data",
                    "date": available_dates,
                    "maps": available_maps
                })

            elif action == "heatmap_data":
                data_payload = payload.get("data", {})
                match_date = data_payload.get("date")
                target_match_id = data_payload.get("match_id")

                if not match_date or not target_match_id:
                    await websocket.send_json({
                        "type": "error",
                        "message": (
                            "Missing required 'date' "
                            "or 'match_id' properties."
                        )
                    })
                    continue

                match_df = gameplay_engine.load_match_data(
                    match_date,
                    target_match_id
                )

                if match_df.empty:
                    await websocket.send_json({
                        "type": "heatmap_response",
                        "data": {
                            "error":
                            f"No telemetry files found for "
                            f"Match ID {target_match_id}"
                        }
                    })
                    continue

                heatmap_results = gameplay_engine.get_heatmap_payload(match_df)
                await websocket.send_json({"type": "heatmap_response","data": heatmap_results})

            elif action == "get_matches_per_date":
                match_date = payload.get("data","February_14")
                result_data = (gameplay_engine.get_matches_for_date(match_date))
                await websocket.send_json({ "type": "get_matches_per_date", "data": result_data})

            elif action == "get_match_playback":
                print("match_date>>")
                match_date = payload.get( "data", "February_14")
                match_id = payload.get( "data_2", None)
                if match_id is None:
                    result_data = gameplay_engine.run_gameplay( date=match_date, highest_player_match=True)
                else:
                    result_data = gameplay_engine.run_gameplay( date=match_date, highest_player_match=False, match_id= match_id)
                print("result_data>>", result_data)
                await websocket.send_json({
                    "type": "game_play",
                    "data": result_data
                })
          
            else:
                await websocket.send_json({ "type": "error", "message": f"Unknown action: {action}"})

    except WebSocketDisconnect:
        print("Frontend client disconnected.")

    except Exception as e:
        print(f"WebSocket error: {e}")


if __name__ == "__main__":
    import uvicorn
    port = int(os.environ.get("PORT", 10000))
    uvicorn.run( app, host="0.0.0.0", port=port, log_level="info")