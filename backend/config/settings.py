import os
from pathlib import Path

# Base directory referencing the root of the project
BASE_DIR = Path(__file__).resolve().parent.parent

# Data directory configurations
DATA_DIR = BASE_DIR / "data"
PLAYER_DATA_DIR = DATA_DIR / "player_data"

# Application Settings
API_PREFIX = ""
DEBUG_MODE = os.getenv("DEBUG_MODE", "True").lower() == "true"