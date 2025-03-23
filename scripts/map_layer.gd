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

	## TODO: Its a little bit inconsisent, may need to rework a lot though,
	## so good enough? Problem is that the land tiles near the water are considered water tiles.
	for x in range(building_size.x):
		for y in range(building_size.y):
			for tile_type in Enums.TileType.values():
				match tile_type:
					Enums.TileType.WATER:
						source_id = water_layer.get_cell_source_id(get_snapped_local_position(building_size) + Vector2(x, y))
					Enums.TileType.DIRT:
						source_id = dirt_layer.get_cell_source_id(get_snapped_local_position(building_size) + Vector2(x, y))
					Enums.TileType.STONE:
						source_id = stone_layer.get_cell_source_id(get_snapped_local_position(building_size) + Vector2(x, y))
					Enums.TileType.GRASS:
						source_id = grass_layer.get_cell_source_id(get_snapped_local_position(building_size) + Vector2(x, y))
					Enums.TileType.RESOURCE:
						source_id = water_layer.get_cell_source_id(get_snapped_local_position(building_size) + Vector2(x, y))
				## If the invalid cell type does exist
				if source_id >= 0 and tile_type not in valid_tile_types_to_place:
					# print(Enums.tile_type_to_string(tile_type))
					# print(x,y)
					return false
	return true

## Function to get the position snapped to the nearest tile on tile map, grid based
func get_snapped_local_position(building_size: Vector2) -> Vector2:
	var world_mouse_pos = get_parent().get_global_mouse_position()
	var local_mouse_pos = dirt_layer.to_local(world_mouse_pos)
	var tile_pos = dirt_layer.local_to_map(local_mouse_pos)
	return tile_pos
	
## Function to set the variable for if the mouse in the map bounds
func set_in_map(is_in_map):
	mouse_in_map = is_in_map
