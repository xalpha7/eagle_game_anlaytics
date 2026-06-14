import logging
from contextlib import asynccontextmanager
from fastapi import FastAPI
from fastapi.middleware.cors import CORSMiddleware
from api.routes import router
from services.parquet_loader import ParquetLoader

# Standard Logging Configuration
logging.basicConfig(
    level=logging.INFO,
    format="%(asctime)s - %(name)s - %(levelname)s - %(message)s"
)
logger = logging.getLogger(__name__)

@asynccontextmanager
async def lifespan(app: FastAPI):
    """
    Application lifecycle hook. 
    Loads the Parquet datasets entirely into memory on startup and sets application state.
    """
    logger.info("Starting LILA BLACK Analytics Backend...")
    try:
        loader = ParquetLoader()
        loader.load_data()
        
        # Cache the dataframe globally
        app.state.df = loader.get_dataframe()
        logger.info("Data loaded successfully. Application is ready.")
    except Exception as e:
        logger.error(f"Critical error loading data: {e}")
        # Allow the application to start for health-checks, but with empty data
        import pandas as pd
        app.state.df = pd.DataFrame()
        
    yield
    
    logger.info("Shutting down gracefully...")

# Initialize FastAPI application
app = FastAPI(
    title="LILA BLACK Analytics API",
    description="Backend API providing endpoints to power gameplay visualization.",
    version="1.0.0",
    lifespan=lifespan
)

# Enable CORS for decoupled AI frontend integration
app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"], 
    allow_credentials=True,
    allow_methods=["GET"], # Only GET methods are required for analytics
    allow_headers=["*"],
)

# Bind the router to root path
app.include_router(router)

if __name__ == "__main__":
    import uvicorn
    uvicorn.run("app:app", host="0.0.0.0", port=8000, reload=True)