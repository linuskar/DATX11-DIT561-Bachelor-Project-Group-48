extends Node
## A class that manages the different states of the game
##
## A class that manages the different states of the game
##

signal build_mode

enum State {
	IDLE,
	PLACE_BUILDING
}

func set_state(new_state: State):
	previous_state = state
	state = new_state

var state: State
var previous_state: State

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	set_state(State.IDLE)
