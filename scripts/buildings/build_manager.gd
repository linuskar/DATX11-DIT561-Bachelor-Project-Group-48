class_name BuildManager
extends Node
## A class that manages the building aspect of the game.
##
## A class that manages the building aspect of the game by allowing the player
## via input to place out buildings in a grid based manner, checking 
## for valid placements. The buildings are preloaded in a dictionary.
##
static var astar
## The blueprint previews the building you are about to place.
@export var blueprint: Building
## The grid size of the map.
@export var grid_size: int = 32

## The layer the building is placed/locked on to get a grid based placement.
@onready var map_layer: MapLayer = $"../MapLayer"

## The currently occupied tiles, for example a building, tree, etc.
var occupied_tiles: Dictionary = BuildManagerGlobal.occupied_tiles

## The colors highlighthing the placment of builings.
var valid_placement_color: Color = Color(0.5, 0.5, 1, 0.8) 
var invalid_placement_color: Color = Color(1, 0.5, 0.5, 0.8)
var default_color: Color = Color(1, 1, 1, 1)

## The buildings in the game that you can place.
@export var buildings: Dictionary[Enums.BuildingType, Resource]
## The blueprints for the buildings that you can place.
@export var building_blueprints: Dictionary[Enums.BuildingType, Resource]

## The buildings in the game that are currently placed.
var buildings_placed: Array[Building]

## The buildings in the game that are currently placed and gathering resources.
var buildings_gathering_resources: Array[Building]

## Boolean for checking valid placement.
var valid_placement: bool = false

## A signal for when a building is placed.
signal placed_building(building: Building)

func _ready() -> void:
	
	astar = BuildManagerGlobal.create_astar_grid()
	$astar_visualizer.visualize(astar)
	
	StateManager.build_mode.connect(_on_build_mode)
	StateManager.selected_building.connect(_on_selected_building)
	
## Function that gets called when a building is selected to build
func _on_selected_building(building_data: BuildingData) ->  void:
	StateManager.set_state(StateManager.State.SELECTED_BUILDING)
	## Delete the current blueprint
	blueprint.queue_free()
	
	## Add the new blueprint to the game of the currently selected building
	var new_blueprint: Building = building_blueprints.get(building_data.building_type).instantiate()
	add_child(new_blueprint)
	blueprint = new_blueprint
	blueprint.show()
		
func _process(_delta) -> void:
	## In build mode snap the blueprint to the mouse in the world
	match StateManager.state:
		StateManager.State.SELECTED_BUILDING:
			_update_blueprint()
		StateManager.State.PLACE_BUILDING:
			_update_blueprint()
				
			if valid_placement:
				place_building()
		StateManager.State.IDLE:
			pass	

## Function for updating the placement of the building blueprint
func _update_blueprint():
	var grid_pos: Vector2 = get_snapped_world_position()
	blueprint.position = grid_pos

	## Checking for valid placement
	if is_tile_occupied(grid_pos) or map_layer.can_place_building(blueprint) == false:
		blueprint.modulate = invalid_placement_color
		valid_placement = false
	else:
		blueprint.modulate = valid_placement_color	
		valid_placement = true	
	
func _input(event: InputEvent) -> void:
	## When trying to place a building that is selected
	if event.is_action_pressed("place") and valid_placement and StateManager.state == StateManager.State.SELECTED_BUILDING:
		StateManager.set_state(StateManager.State.PLACE_BUILDING)
		
	## The case where the action for placing buildings is released
	if event.is_action_released("place") and StateManager.state == StateManager.State.PLACE_BUILDING:
		StateManager.set_state(StateManager.State.SELECTED_BUILDING)

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
	BuildManagerGlobal.update_roads.emit()

## When the mouse has entered the building list:
## Disable the state of placing a building and hide the blueprint
func _on_user_interface_build_list_entered() -> void:
	StateManager.set_state(StateManager.State.IDLE)
	_on_build_mode()
	
## When the mouse has exited the building list with a selected building:
## Set the currently selected building and show its blueprint
func _on_user_interface_building_wanted(building: BuildingData) -> void:
	if not building == null:
		StateManager.set_state(StateManager.State.SELECTED_BUILDING)
		_on_selected_building(building)
		_on_build_mode()
