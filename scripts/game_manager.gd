class_name GameManager
extends Node

var is_building: bool 
var occupied_tiles: Dictionary = {}

@onready var build_manager: BuildManager = $"../BuildManager"
signal build_mode(is_building)

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	build_manager.placed_building.connect(_on_placed_building)
	is_building = false

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _input(event) -> void:
	if event.is_action_pressed("build"):
		is_building = !is_building
		build_mode.emit(is_building)

func is_tile_occupied(position: Vector2) -> bool:
	return occupied_tiles.has(position)

func _on_placed_building(building: Building) -> void:
	occupied_tiles[building.position] = building
	#print(occupied_tiles.size())
