extends Node

@export var blueprint: Building
@export var grid_size: int = 32

@onready var world_layer: TileMapLayer = $"../WorldLayer"
@onready var game_manager = $"../GameManager"

var factory: Resource = preload("res://factory.tscn")

var buildings: Dictionary = {
	"factory": factory,
}

var buildings_placed: Array[Building]

var in_build_mode: bool = false

func _ready() -> void:
	game_manager.build_mode.connect(_on_build_mode)

func _process(delta):
	if in_build_mode:
		var tile_pos = world_layer.local_to_map(get_parent().get_local_mouse_position())
		var world_pos = world_layer.map_to_local(tile_pos)
		
		blueprint.position = world_pos 

func _input(event):
	var tile_pos = world_layer.local_to_map(get_parent().get_local_mouse_position())
	var world_pos = world_layer.map_to_local(tile_pos)
		
	if in_build_mode and event.is_action_pressed("place"):
		place_building()

func snap_to_grid(pos, grid_size):
	return Vector2(round(pos.x / grid_size) * grid_size, round(pos.y / grid_size) * grid_size)

func place_building():
	in_build_mode = false
	
	var new_building: Building = buildings.get("factory").instantiate()
	new_building.position = blueprint.position
	buildings_placed.append(new_building)
	
	game_manager.add_child(new_building)
	game_manager.build_mode.emit(in_build_mode)
	# print(buildings_placed.size())
	
func _on_build_mode(is_building) -> void:
	in_build_mode = is_building
	
	if(in_build_mode):
		blueprint.show()
	else:
		blueprint.hide()  
