import io
import base64
import numpy as np
import pandas as pd
from PIL import Image, ImageFilter

def generate_heatmap_b64(pixel_x_series: pd.Series, pixel_y_series: pd.Series) -> str:
    """
    Generates a 1024x1024 heatmap as a base64 encoded PNG from pixel coordinates.
    Uses fast NumPy accumulation and smooth Pillow Gaussian blur filtering.
    """
    grid = np.zeros((1024, 1024), dtype=np.float32)
    
    if not pixel_x_series.empty and not pixel_y_series.empty:
        x_indices = np.clip(pixel_x_series.to_numpy().astype(np.int32), 0, 1023)
        y_indices = np.clip(pixel_y_series.to_numpy().astype(np.int32), 0, 1023)
        np.add.at(grid, (y_indices, x_indices), 1.0)
    
    if grid.max() == 0:
        img = Image.new("RGBA", (1024, 1024), (0, 0, 0, 0))
    else:
        max_val = grid.max()
        normalized = (grid / max_val * 255).astype(np.uint8)
        
        density_img = Image.fromarray(normalized, mode="L")
        density_img = density_img.filter(ImageFilter.GaussianBlur(radius=8))
        blurred_arr = np.array(density_img)
        
        r = np.ones_like(blurred_arr) * 255
        g = 255 - blurred_arr
        b = np.zeros_like(blurred_arr)
        a = (blurred_arr.astype(np.float32) * 1.2).clip(0, 255).astype(np.uint8)
        
        rgba_arr = np.stack([r, g, b, a], axis=-1)
        img = Image.fromarray(rgba_arr, mode="RGBA")
    
    buffer = io.BytesIO()
    img.save(buffer, format="PNG")
    b64_str = base64.b64encode(buffer.getvalue()).decode("utf-8")
    return f"data:image/png;base64,{b64_str}"