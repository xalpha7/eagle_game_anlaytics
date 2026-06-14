import io
import pandas as pd
import numpy as np
from enum import Enum
from PIL import Image, ImageFilter

class HeatmapType(str, Enum):
    TRAFFIC = "TRAFFIC"
    KILLS = "KILLS"
    DEATHS = "DEATHS"
    LOOT = "LOOT"

class HeatmapService:
    """Calculates density heatmaps and renders them to PNG using pure PIL & NumPy."""
    
    EVENT_MAPPING = {
        HeatmapType.TRAFFIC: ['Position', 'BotPosition'],
        HeatmapType.KILLS: ['Kill', 'BotKill'],
        HeatmapType.DEATHS: ['Killed', 'BotKilled', 'KilledByStorm'],
        HeatmapType.LOOT: ['Loot']
    }

    def __init__(self, df: pd.DataFrame):
        self.df = df

    def generate_heatmap(self, map_id: str, heatmap_type: HeatmapType) -> bytes:
        """
        Generates a 1024x1024 transparent PNG heatmap.
        Uses red mapping where pixel density sets the alpha channel.
        """
        # Filter dataframe by map and relevant events
        valid_events = self.EVENT_MAPPING[heatmap_type]
        filtered_df = self.df[(self.df['map_id'] == map_id) & (self.df['event'].isin(valid_events))]
        
        # 1. Prepare data for NumPy histogram
        if filtered_df.empty:
            x_data, y_data = [], []
        else:
            x_data = filtered_df['pixel_x'].values
            y_data = filtered_df['pixel_y'].values
            
        # 2. Generate 2D density histogram (Bins = 1024 ensures a 1024x1024 matrix)
        heatmap, _, _ = np.histogram2d(
            x_data, 
            y_data, 
            bins=[1024, 1024], 
            range=[[0, 1024], [0, 1024]]
        )
        
        # histogram2d returns the x axis as rows, we transpose so y axis represents rows
        heatmap = heatmap.T
        
        # 3. Normalize intensity values (0 to 255)
        max_density = heatmap.max()
        if max_density > 0:
            heatmap = (heatmap / max_density) * 255
            
        heatmap = heatmap.astype(np.uint8)
        
        # 4. Generate PIL Grayscale Image & apply Gaussian Blur
        alpha_channel = Image.fromarray(heatmap, mode='L')
        # Standard blur radius to create a smooth, continuous heat visual
        alpha_channel = alpha_channel.filter(ImageFilter.GaussianBlur(radius=8)) 
        
        # 5. Composite into an RGBA format (Red color with density-based alpha)
        # Using Solid Red color logic.
        red_channel = Image.new("L", (1024, 1024), 255)
        zero_channel = Image.new("L", (1024, 1024), 0)
        
        heatmap_rgba = Image.merge(
            "RGBA", 
            (red_channel, zero_channel, zero_channel, alpha_channel)
        )
        
        # 6. Save directly to bytes for FastAPI Response
        img_byte_arr = io.BytesIO()
        heatmap_rgba.save(img_byte_arr, format='PNG')
        return img_byte_arr.getvalue()