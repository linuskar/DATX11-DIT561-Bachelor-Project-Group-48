class_name BuildManager
extends Node

@export var blueprint: Building
@export var grid_size: int = 32

@onready var world_layer: TileMapLayer = $"../WorldLayer"
@onready var game_manager: GameManager = $"../GameManager"

var valid_placement_color: Color = Color(0.5, 0.5, 1, 0.8) 
var invalid_placement_color: Color = Color(1, 0.5, 0.5, 0.8)
var default_color: Color = Color(1, 1, 1, 1)

var buildings: Dictionary = {
	"factory": preload("res://factory.tscn"),
}

var buildings_placed: Array[Building]

var in_build_mode: bool = false
var valid_placement: bool = false

signal placed_building(building: Building)

func _ready() -> void:
	game_manager.build_mode.connect(_on_build_mode)
	
func _process(delta) -> void:
	if in_build_mode:
		var mouse_pos: Vector2 = get_parent().get_local_mouse_position()
		var tile_pos: Vector2 = world_layer.local_to_map(mouse_pos)
		var world_pos: Vector2 = world_layer.map_to_local(tile_pos)
		
		blueprint.position = world_pos 
		
		if game_manager.is_tile_occupied(world_pos):
			blueprint.modulate = invalid_placement_color
			valid_placement = false
		else:
			blueprint.modulate = valid_placement_color	
			valid_placement = true	

func _input(event) -> void:
	if in_build_mode and event.is_action_pressed("place") and valid_placement:
		place_building()
		
func _on_build_mode(is_building) -> void:
	in_build_mode = is_building
	
	if(in_build_mode):
		blueprint.show()
		blueprint.modulate = valid_placement_color
	else:
		blueprint.hide()  
		blueprint.modulate = default_color
		
func place_building() -> void:
	var new_building: Building = buildings.get("factory").instantiate()
	new_building.position = blueprint.position
	buildings_placed.append(new_building)
	game_manager.add_child(new_building)
	placed_building.emit(new_building)
