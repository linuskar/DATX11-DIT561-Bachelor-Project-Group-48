extends Node

var is_building: bool 

signal build_mode(is_building)

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	is_building = false

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _input(event):
	if event.is_action_pressed("build"): #or (is_building and event.is_action_pressed("place")):
		is_building = !is_building
		build_mode.emit(is_building)
