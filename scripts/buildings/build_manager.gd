class_name BuildManager
extends Node
## A class that manages the building aspect of the game.
##
## A class that manages the building aspect of the game by allowing the player
## via input to place out buildings in a grid based manner, checking 
## for valid placements. The buildings are preloaded in a dictionary.
##

## The blueprint previews the building you are about to place.
@export var blueprint: Building
## The grid size of the map.
@export var grid_size: int = 32

## The layer the building is placed/locked on to get a grid based placement.
@onready var map_layer: MapLayer = $"../MapLayer"

## The currently occupied tiles, for example a building, tree, etc.
var occupied_tiles: Dictionary = {}

## The colors highlighthing the placment of builings.
var valid_placement_color: Color = Color(0.5, 0.5, 1, 0.8) 
var invalid_placement_color: Color = Color(1, 0.5, 0.5, 0.8)
var default_color: Color = Color(1, 1, 1, 1)

## The buildings in the game that you can place.
var buildings: Dictionary = {
	Enums.BuildingType.FACTORY: preload("res://scenes/buildings/factory.tscn"),
	Enums.BuildingType.IRON_MINE: preload("res://scenes/buildings/iron_miner.tscn"),
	Enums.BuildingType.COAL_MINE: preload("res://scenes/buildings/coal_miner.tscn"),
	Enums.BuildingType.WOOD_CUTTER: preload("res://scenes/buildings/wood_cutter.tscn"),
}

## The builings in the game that are currently place.
var buildings_placed: Array[Building]
var buildings_gathering_resources: Array[Building]

## Boolean for checking valid placement.
var valid_placement: bool = false

## A signal for when a building is placed.
signal placed_building(building: Building)

func _ready() -> void:
	StateManager.build_mode.connect(_on_build_mode)
	StateManager.selected_building.connect(_show_blueprint_of_selected_building)

func _show_blueprint_of_selected_building(building_data):
	blueprint.building_data = building_data
	blueprint.show()

func _process(_delta) -> void:
	match StateManager.state:
		StateManager.State.SELECTED_BUILDING:
			var grid_pos: Vector2 = get_snapped_world_position()
			blueprint.position = grid_pos
			## Checking for valid placement
			if is_tile_occupied(grid_pos):
				blueprint.modulate = invalid_placement_color
				valid_placement = false
			else:
				blueprint.modulate = valid_placement_color	
				valid_placement = true	
				
			if Input.is_action_pressed("place") and valid_placement:
				StateManager.set_state(StateManager.State.PLACE_BUILDING)
				#place_building()
		## In build mode snap the blueprint to the mouse in the world
		StateManager.State.PLACE_BUILDING:
			place_building()
			print("placed")
		StateManager.State.IDLE:
			pass	
				
## Returns the world position of the mouse snapped to the nearest tile on the grid.
## This function converts the mouse position from world space to tile coordinates
## and then back to a snapped world position using a tilemap layer
func get_snapped_world_position() -> Vector2:
	## Don't know if this is the best. But one of TileMapLayers just gets picked
	## to get access to get the related functions to call
	var dirt_layer: TileMapLayer = map_layer.dirt_layer
	## Mouse position in world coordinates
	var world_mouse_pos: Vector2 = get_parent().get_global_mouse_position()  
	## Convert to local TileMap coordinates
	var local_mouse_pos: Vector2 = dirt_layer.to_local(world_mouse_pos)  
	## Get tile coordinates
	var tile_pos: Vector2 = dirt_layer.local_to_map(local_mouse_pos)  
	## Convert back to local position
	var snapped_local_pos: Vector2 = dirt_layer.map_to_local(tile_pos)  
	
	## Return the world coordinates
	return dirt_layer.to_global(snapped_local_pos)

## Function that is called when build mode signal is emitted
func _on_build_mode() -> void:
	match StateManager.state:
		## When not in build mode hide the blueprint
		StateManager.State.IDLE:
			blueprint.hide()  
			blueprint.modulate = default_color
		## When in build mode to place a building show the blueprint
		StateManager.State.SELECTED_BUILDING:
			blueprint.show()
			blueprint.modulate = valid_placement_color
			
## Function for placing down a building
func place_building() -> void:
	## Instantiate the building and add it to the game and world
	var building_type: Enums.BuildingType = blueprint.building_data.building_type
	var new_building: Building = buildings.get(building_type).instantiate()
	new_building.position = blueprint.position
	get_parent().add_child(new_building)
	_on_placed_building(new_building)

## Function checking if a tile is occupied by another object
func is_tile_occupied(position: Vector2) -> bool:
	return occupied_tiles.has(position)
	
## Function marking a tile as occupied for placing down a buiiling
func _on_placed_building(building: Building) -> void:
	occupied_tiles[building.position] = building
	placed_building.emit(building)
	StateManager.set_state(StateManager.State.SELECTED_BUILDING)
