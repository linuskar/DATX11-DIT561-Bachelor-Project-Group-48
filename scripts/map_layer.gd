class_name MapLayer
extends Node2D
## A class that representing the layers of the game map
##
## A class that representing the differemt TileMapLayers of the game map
##

## The water layer of the TileMap
@onready var water_layer: TileMapLayer = $Water
## The diort layer of the TileMap
@onready var dirt_layer: TileMapLayer = $Dirt
## The stone layer of the TileMap
@onready var stone_layer: TileMapLayer = $Stone
## The grass layer of the TileMap
@onready var grass_layer: TileMapLayer = $Grass
## The resources layer of the TileMap
@onready var resources_layer: TileMapLayer = $Resources

## Function checking if there is valid types of cells for the
## building to placed on, based on the position of the mouse
func can_place_building(building: Building) -> bool:
	var valid_tiles_to_place: Array[Enums.TileType] = building.building_data.valid_placeable_tiles
	var source_id = null
	
	## Check if any valid cells exists at the 
	## position that the building is placed
	for tile_type in valid_tiles_to_place:
		## Mouse position in world coordinates
		var world_mouse_pos: Vector2 = get_parent().get_global_mouse_position()  
		## Convert to local TileMap coordinates
		var local_mouse_pos: Vector2 = dirt_layer.to_local(world_mouse_pos)  
		var tile_pos: Vector2 
		
		match tile_type:
			Enums.TileType.WATER:
				## See if the cell exists at the position
				tile_pos = water_layer.local_to_map(local_mouse_pos) 
				source_id = water_layer.get_cell_source_id(tile_pos)
			Enums.TileType.DIRT:
				tile_pos = dirt_layer.local_to_map(local_mouse_pos) 
				source_id = dirt_layer.get_cell_source_id(tile_pos)
			Enums.TileType.STONE:
				tile_pos = stone_layer.local_to_map(local_mouse_pos) 
				source_id = stone_layer.get_cell_source_id(tile_pos)
			Enums.TileType.GRASS:
				tile_pos = grass_layer.local_to_map(local_mouse_pos) 
				source_id = grass_layer.get_cell_source_id(tile_pos)
			Enums.TileType.RESOURCE:
				tile_pos = resources_layer.local_to_map(local_mouse_pos) 
				source_id = resources_layer.get_cell_source_id(tile_pos)
				
		## If the cell does exist
		if source_id != -1:
			return true
			
	return false
