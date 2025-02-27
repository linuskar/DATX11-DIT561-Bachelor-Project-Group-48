extends Node

var is_building: bool 
var occupied_tiles: Dictionary = {}

@onready var build_manager: BuildManager = $BuildManager

enum State {
	IDLE,
	PLACE_BUILDING
}

func set_state(new_state: State):
	previous_state = state
	state = new_state

var state: State
var previous_state: State

signal build_mode()

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	set_state(State.IDLE)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _input(event) -> void:
	if event.is_action_pressed("build"):
		match state:
			State.IDLE:
				set_state(State.PLACE_BUILDING)
			State.PLACE_BUILDING:
				set_state(State.IDLE)
				
		build_mode.emit()
	
	if event.is_action_pressed("i"):
		$"../Control".visible = !$"../Control".visible

func is_tile_occupied(position: Vector2) -> bool:
	return occupied_tiles.has(position)

func _on_placed_building(building: Building) -> void:
	occupied_tiles[building.position] = building
	#print(occupied_tiles.size())
