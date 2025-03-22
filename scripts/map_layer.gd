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

## The bounds of the map, i.e. the playable area
@onready var map_bounds: MapBounds = $MapBounds

## Variable for if the mouse in the map bounds
var mouse_in_map: bool

var last_checked_tile = Vector2i(-9999, -9999)  # Stores the last checked tile position

func _ready() -> void:
	map_bounds.mouse_in_map.connect(set_in_map)
	
## Function checking if there is valid types of cells for the
## building to placed on, based on the position of the mouse
func can_place_building(building: Building) -> bool:
	if mouse_in_map == false:
		# print("not in map")
		return false
	
	var valid_tile_types_to_place: Array[Enums.TileType] = building.building_data.valid_tile_types_to_place_on
	var source_id = null
	var building_size: Vector2 = building.building_data.building_size
	
	## Mouse position in world coordinates
	var world_mouse_pos: Vector2 = get_parent().get_global_mouse_position()  
	## Convert to local TileMap coordinates
	var local_mouse_pos: Vector2 
	var tile_pos: Vector2i
	
	var grid_size: int = 32
	
	## TODO: Its a little bit inconsisent, may need to rework a lot though,
	## so good enough?
	## TODO: refactor
	for x in range(building_size.x):
		for y in range(building_size.y):
			for tile_type in Enums.TileType.values():
				match tile_type:
					Enums.TileType.WATER:
						local_mouse_pos = water_layer.to_local(world_mouse_pos) 
						tile_pos = water_layer.local_to_map(local_mouse_pos + Vector2(x, y))  
						#if tile_pos != last_checked_tile:
						#	pass
						#get_snapped_local_position(building_size)
						if building_size.x == 3 and building_size.y == 3:
							source_id = water_layer.get_cell_source_id(get_snapped_local_position(building_size) + Vector2(x+1, y+1))
						else:
							source_id = water_layer.get_cell_source_id(get_snapped_local_position(building_size) + Vector2(x, y))
					Enums.TileType.DIRT:
						local_mouse_pos = dirt_layer.to_local(world_mouse_pos)
						
						tile_pos = dirt_layer.local_to_map(local_mouse_pos + Vector2(x, y)) 
						source_id = dirt_layer.get_cell_source_id(get_snapped_local_position(building_size) + Vector2(x, y))
					Enums.TileType.STONE:
						local_mouse_pos = stone_layer.to_local(world_mouse_pos)
						
						tile_pos = stone_layer.local_to_map(local_mouse_pos + Vector2(x, y)) 
						source_id = stone_layer.get_cell_source_id(get_snapped_local_position(building_size) + Vector2(x, y))
					Enums.TileType.GRASS:
						local_mouse_pos = grass_layer.to_local(world_mouse_pos)
						
						tile_pos = grass_layer.local_to_map(local_mouse_pos + Vector2(x, y)) 
						source_id = grass_layer.get_cell_source_id(get_snapped_local_position(building_size) + Vector2(x, y))
					Enums.TileType.RESOURCE:
						local_mouse_pos = resources_layer.to_local(world_mouse_pos)
						
						tile_pos = resources_layer.local_to_map(local_mouse_pos + Vector2(x, y)) 
						source_id = resources_layer.get_cell_source_id(get_snapped_local_position(building_size) + Vector2(x, y))
				## If the cell does exist
				if source_id >= 0 and tile_type not in valid_tile_types_to_place:
					print(Enums.tile_type_to_string(tile_type))
					print(tile_pos)
					print(x,y)
					return false
	return true
	
## Returns the world position of the mouse snapped to the nearest tile on the grid.
## This function converts the mouse position from world space to tile coordinates
## and then back to a snapped world position using a tilemap layer
func get_snapped_local_position(building_size: Vector2) -> Vector2:
	var world_mouse_pos = get_parent().get_global_mouse_position()
	var local_mouse_pos = dirt_layer.to_local(world_mouse_pos)
	var tile_coords = dirt_layer.local_to_map(local_mouse_pos)

	# Offset to align building's top-left corner
	tile_coords -= Vector2i(floor(building_size.x / 2), floor(building_size.y / 2))

	## Return the world coordinates
	return tile_coords
	
## Function to set the variable for if the mouse in the map bounds
func set_in_map(is_in_map):
	mouse_in_map = is_in_map
	
