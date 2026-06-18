## What i built ?
* For the backend part i have considered using the websockets api and uvicorn to keep the server running. 
* i have used the websockets to maintain a bi directional communication between server and client. the websocket communication is fast. For a general use case when the frontend ask for the gamplay data the data is prepared and server independently deliver when the data is ready.
* I have used the pandas and pyarrow to read and crate dataframe for parquet files.
* For the frontend i have used the flutter as it is a powerful framework to code and deploy. 
* Addtionally the statemanagement tools like getx make it easy to maintain a data flow globally.

## How data flows from the parquet files to what shows up on screen
[Parquet Files (.nakama-0)] ──(PyArrow/Pandas)──> [Unified DataFrame] 
                                                        │
                                           (Coordinate Mapping & Labeling)
                                                        │
                                                        ▼
[Flutter UI Layout (Stack/Positioned)] <──(GetX/Obx)── [JSON Timeline Payload]


* Raw match telemetry is stored on disk in date-structured folders as split Parquet chunks (.nakama-0 files).
* GameEngine uses pyarrow to read the binary tables and concats them into a single, unified Pandas DataFrame based on a requested match_id
* The engine reads raw 3D game vectors ($X$ and $Z$). It uses predefined map limits (origin_x, origin_z, scale) to normalize world space into a strict  1024x1024.
* Players are categorized on the fly: numeric string IDs are flagged as server bots (is_bot = True), while alpha-numeric strings are flagged as actual human users.
* Then DataFrame is sorted chronologically by timestamp (ts) and hence the timeline is produced which is sent to the fronend 
* The data is fetched and stored in a list in frontend . where i have used a timer to play the player as playerpainter with their events. I have used the heatmap painter to paint heatmaps. 
* A painter is a ui attributes render in the screen. just like drawing in a canvas 

## Coordinate Mapping Approach
The game records world coordinates using raw spatial positions, but our UI maps use different sizes (like a $1024 \times 1024$ canvas). 

To ensure players line up perfectly on any size map layout, we turn coordinates into a **fraction (percentage)** of the total map width before drawing them:
1. **Normalize to Corner:** Shift the player position relative to the map's far-left wall (`origin_x`): 
   $$Distance = X_{game} - Origin_X$$
2. **Convert to Percentage:** Divide that distance by the total map length (`scale`) to find how far across the map the player is (from 0.0 to 1.0).
3. **Scale to Screen:** Multiply that percentage by the actual width ($W$) of your Flutter screen component:
   $$Pixel_X = \left( \frac{X_{game} - Origin_X}{Scale} \right) \times W$$



## Data Assumptions & Ambiguities
* **Missing Combat Context:** The dataset lacks "who shot whom" and weapon types.
* **Missing Storm/Circle Telemetry:** There is no data tracking the movement or size of the phase storm.
* **The Missing Piece**: How do you know when a match actually finished? the file lack a match end event. 
## Major Trade-offs
| Consideration | What We Did | Trade-off / Why? |
| :--- | :--- | :--- |
| **2D Minimap vs. 3D Render Engine** | Plotted 3D ($X, Y, Z$) points onto a flat 2D image map. | **Pros:** Keeps application size small, fast loading times, and low rendering complexity. **Cons:** Loses vertical precision when players are on different floors of a building. |
