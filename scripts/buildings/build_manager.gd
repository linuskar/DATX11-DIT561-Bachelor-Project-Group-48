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
@onready var map_layer: Node2D = $"../MapLayer"

## The currently occupied tiles, for example a building, tree, etc.
var occupied_tiles: Dictionary = {}

## The colors highlighthing the placment of builings.
var valid_placement_color: Color = Color(0.5, 0.5, 1, 0.8) 
var invalid_placement_color: Color = Color(1, 0.5, 0.5, 0.8)
var default_color: Color = Color(1, 1, 1, 1)

## The buildnigs in the game that you can place.
var buildings: Dictionary = {
	"factory": preload("res://scenes/buildings/factory.tscn"),
}

## The builings in the game that are currently place.
var buildings_placed: Array[Building]

## Boolean for checking valid placement.
var valid_placement: bool = false

## A signal for when a building is placed.
signal placed_building

func _ready() -> void:
	StateManager.build_mode.connect(_on_build_mode)
	
func _process(_delta) -> void:
	match StateManager.state:
		## In build mode snap the blueprint to the mouse in the world
		# TODO: add placeable layers
		StateManager.State.PLACE_BUILDING:
			#var mouse_pos: Vector2 = get_parent().get_local_mouse_position()
			#var tile_pos: Vector2 = map_layer.get_child(1).local_to_map(mouse_pos) 
			#var world_pos: Vector2 = map_layer.get_child(1).map_to_local(tile_pos)
			var ground = map_layer.get_child(1)
			var mouse_pos = get_parent().get_global_mouse_position()  # Get world position of mouse
			var local_mouse_pos = ground.to_local(mouse_pos)  # Convert to local TileMap coordinates
			var tile_pos = ground.local_to_map(local_mouse_pos)  # Get tile coordinates
			var snapped_pos = ground.map_to_local(tile_pos)  # Convert back to local space
			blueprint.position = ground.to_global(snapped_pos)
			
			## Checking for valid placement
			if is_tile_occupied(ground.to_global(snapped_pos)):
				blueprint.modulate = invalid_placement_color
				valid_placement = false
			else:
				blueprint.modulate = valid_placement_color	
				valid_placement = true				
			if Input.is_action_pressed("place") and valid_placement:
				place_building()
				
		StateManager.State.IDLE:
			pass		

## Function that is called when build mode signal is emitted
func _on_build_mode() -> void:
	match StateManager.state:
		## When not in build mode hide the blueprint
		StateManager.State.IDLE:
			blueprint.hide()  
			blueprint.modulate = default_color
		## When in build mode to place a building show the blueprint
		StateManager.State.PLACE_BUILDING:
			blueprint.show()
			blueprint.modulate = valid_placement_color
			
## Function for placing down a building
func place_building() -> void:
	## Instantiate the building and add it to the game and world
	var new_building: Building = buildings.get("factory").instantiate()
	new_building.position = blueprint.position
	buildings_placed.append(new_building)
	get_parent().add_child(new_building)
	_on_placed_building(new_building)

## Function checking if a tile is occupied by another object
func is_tile_occupied(position: Vector2) -> bool:
	return occupied_tiles.has(position)
	
## Function marking a tile as occupied for placing down a buiiling
func _on_placed_building(building: Building) -> void:
	occupied_tiles[building.position] = building
