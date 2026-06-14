from typing import Tuple
from config.map_config import MAP_CONFIG

def world_to_pixel(map_id: str, x: float, z: float) -> Tuple[float, float]:
    """
    Converts 3D world coordinates (x, z) to 2D pixel coordinates (pixel_x, pixel_y) 
    based on the map's unique scale and origin.
    
    Args:
        map_id (str): The identifier of the map.
        x (float): World X coordinate.
        z (float): World Z coordinate.
        
    Returns:
        Tuple[float, float]: The calculated (pixel_x, pixel_y) on a 1024x1024 canvas.
        
    Raises:
        ValueError: If the map_id is not found in MAP_CONFIG.
    """
    if map_id not in MAP_CONFIG:
        raise ValueError(f"Invalid map_id: {map_id}. Map configuration not found.")
    
    config = MAP_CONFIG[map_id]
    scale = config["scale"]
    origin_x = config["origin_x"]
    origin_z = config["origin_z"]
    
    u = (x - origin_x) / scale
    v = (z - origin_z) / scale
    
    pixel_x = u * 1024.0
    pixel_y = (1.0 - v) * 1024.0
    
    return pixel_x, pixel_y