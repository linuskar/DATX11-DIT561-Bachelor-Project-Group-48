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
## The TileMapLayer responsible for the grid
@onready var grid_layer: TileMapLayer = $Grid

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
	GameStateManager.grid_setting_toggled.connect(toggle_grid_map)
	blueprint_in_map = true
	
## Function checking if there is valid types of cells for the
## building to placed on, based on the position of the mouse
func can_place_building(blueprint: BuildingBlueprint) -> bool:
	var blueprint_size: Vector2 = blueprint.building_data.building_size	
	
	if blueprint_in_map == false or mouse_in_map == false:
		return false
	
	var valid_tile_types_to_place: Array[Enums.TileType] = blueprint.building_data.valid_tile_types_to_place_on
	var source_id: int = -1

	## Note: Its a little bit inconsisent, may need to rework a lot though,
	## so good enough? Problem is that the land tiles near the water are considered water tiles.
	for x in range(blueprint_size.x):
		for y in range(blueprint_size.y):
			for tile_type in Enums.TileType.values():
				match tile_type:
					Enums.TileType.WATER:
						source_id = water_layer.get_cell_source_id(get_snapped_local_position() + Vector2(x, y))
					Enums.TileType.DIRT:
						source_id = dirt_layer.get_cell_source_id(get_snapped_local_position() + Vector2(x, y))
					Enums.TileType.STONE:
						source_id = stone_layer.get_cell_source_id(get_snapped_local_position() + Vector2(x, y))
					Enums.TileType.GRASS:
						source_id = grass_layer.get_cell_source_id(get_snapped_local_position() + Vector2(x, y))
					Enums.TileType.RESOURCE:
						source_id = water_layer.get_cell_source_id(get_snapped_local_position() + Vector2(x, y))
				## If the invalid cell type does exist
				if source_id >= 0 and tile_type not in valid_tile_types_to_place:
					return false
	return true

## Function to check if tile is valid to palce on
func check_valid_tile(position_to_check: Vector2, valid_tile_types_to_place: Array[Enums.TileType]) -> bool:
	var source_id: int = -1
	for tile_type in Enums.TileType.values():
		var tilemap_position = water_layer.local_to_map(water_layer.to_local(position_to_check))
		match tile_type:
			Enums.TileType.WATER:
				source_id = water_layer.get_cell_source_id(tilemap_position)
			Enums.TileType.DIRT:
				source_id = dirt_layer.get_cell_source_id(tilemap_position)
			Enums.TileType.STONE:
				source_id = stone_layer.get_cell_source_id(tilemap_position)
			Enums.TileType.GRASS:
				source_id = grass_layer.get_cell_source_id(tilemap_position)
			Enums.TileType.RESOURCE:
				source_id = water_layer.get_cell_source_id(tilemap_position)
		## If the invalid cell type does exist
		if source_id >= 0 and tile_type not in valid_tile_types_to_place:
			return false
	return true

## Function to get the position snapped to the nearest tile on tile map, grid based
func get_snapped_local_position() -> Vector2:
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

## Function to toggle the grid
func toggle_grid_map(toggled_on: bool) -> void:
	if toggled_on:
		grid_layer.show()
	else:
		grid_layer.hide()
