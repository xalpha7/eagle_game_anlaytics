import os
import pyarrow.parquet as pq

TARGET_FOLDER = "/home/eaglex/eagleSpace/GAME_DEV/eagle_game_analytics/backend/data/player_data/February_10"
TARGET_MAP = "AmbroseValley"

matches = {}

for filename in os.listdir(TARGET_FOLDER):
    if not filename.endswith(".nakama-0"):
        continue

    filepath = os.path.join(TARGET_FOLDER, filename)

    try:
        table = pq.read_table(
            filepath,
            columns=["match_id", "map_id", "user_id"]
        )

        df = table.to_pandas()

        if df.empty:
            continue

        if df["map_id"].iloc[0] != TARGET_MAP:
            continue

        match_id = df["match_id"].iloc[0]

        if match_id not in matches:
            matches[match_id] = set()

        matches[match_id].update(df["user_id"].astype(str).unique())

    except Exception as e:
        print(e)

for match_id, players in matches.items():
    print(f"\nMatch: {match_id}")
    print(f"Players: {len(players)}")
    for player in sorted(players):
        print(f"  {player}")