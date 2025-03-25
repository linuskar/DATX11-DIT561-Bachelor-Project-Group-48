class_name MapLayer
extends Node2D
## A class that representing the layers of the game map.
##
## A class that representing the differemt TileMapLayers of the game map.
##
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

## The areas/bounds of the map, 
## i.e. the playable area and the outer areas/bounds
@onready var map_areas: MapAreas = $MapAreas

## Variable for if the mouse in the playable area
var mouse_in_map: bool
## Variable for if the blueprint is in or outside the playable area
var blueprint_in_map: bool

func _ready() -> void:
	map_areas.mouse_in_map.connect(set_mouse_in_map)
	map_areas.blueprint_in_map.connect(set_blueprint_in_map)
	blueprint_in_map = true
	
## Function checking if there is valid types of cells for the
## building to placed on, based on the position of the mouse
func can_place_building(blueprint: BuildingBlueprint) -> bool:
	var blueprint_size: Vector2 = blueprint.building_data.building_size	
	
	var min_x: float = map_areas.left_bound.position.x
	var max_x: float = map_areas.right_bound.position.x

	var min_y: float = map_areas.upper_bound.position.y
	var max_y: float = map_areas.lower_bound.position.y
	
	var grid_size: int = 32
	## Note: Haven't tested for 2x2
	## Clamp the blueprint position to make it not go out the playable area
	if blueprint_size.x == 3 and blueprint_size.y == 3:
		blueprint.position.x = clampf(blueprint.position.x, min_x + grid_size, max_x - grid_size)
		blueprint.position.y = clampf(blueprint.position.y, min_y + grid_size, max_y - grid_size)
	elif blueprint_size.x == 2 and blueprint_size.y == 2:
		blueprint.position.x = clampf(blueprint.position.x, min_x + grid_size / 2, max_x - grid_size / 2)
		blueprint.position.y = clampf(blueprint.position.y, min_y + grid_size / 2, max_y - grid_size / 2)
	else:
		blueprint.position.x = clampf(blueprint.position.x, min_x, max_x)
		blueprint.position.y = clampf(blueprint.position.y, min_y, max_y)
	
	if blueprint_in_map == false or mouse_in_map == false:
		return false
	
	var valid_tile_types_to_place: Array[Enums.TileType] = blueprint.building_data.valid_tile_types_to_place_on
	var source_id = null

	## Note: Its a little bit inconsisent, may need to rework a lot though,
	## so good enough? Problem is that the land tiles near the water are considered water tiles.
	for x in range(blueprint_size.x):
		for y in range(blueprint_size.y):
			for tile_type in Enums.TileType.values():
				match tile_type:
					Enums.TileType.WATER:
						source_id = water_layer.get_cell_source_id(get_snapped_local_position(blueprint_size) + Vector2(x, y))
					Enums.TileType.DIRT:
						source_id = dirt_layer.get_cell_source_id(get_snapped_local_position(blueprint_size) + Vector2(x, y))
					Enums.TileType.STONE:
						source_id = stone_layer.get_cell_source_id(get_snapped_local_position(blueprint_size) + Vector2(x, y))
					Enums.TileType.GRASS:
						source_id = grass_layer.get_cell_source_id(get_snapped_local_position(blueprint_size) + Vector2(x, y))
					Enums.TileType.RESOURCE:
						source_id = water_layer.get_cell_source_id(get_snapped_local_position(blueprint_size) + Vector2(x, y))
				## If the invalid cell type does exist
				if source_id >= 0 and tile_type not in valid_tile_types_to_place:
					# print(Enums.tile_type_to_string(tile_type))
					return false
	return true

## Function to get the position snapped to the nearest tile on tile map, grid based
func get_snapped_local_position(building_size: Vector2) -> Vector2:
	var world_mouse_pos = get_parent().get_global_mouse_position()
	var local_mouse_pos = dirt_layer.to_local(world_mouse_pos)
	var tile_pos = dirt_layer.local_to_map(local_mouse_pos)
	return tile_pos
	
## Function to set the variable for if the mouse in the map bounds
func set_mouse_in_map(mouse_is_in_map: bool) -> void:
	mouse_in_map = mouse_is_in_map
	
## Function to set the variable for if the mouse in the map bounds
func set_blueprint_in_map(blueprint_is_in_map: bool) -> void:
	blueprint_in_map = blueprint_is_in_map
