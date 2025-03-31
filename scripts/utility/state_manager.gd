extends Node
## A class that manages the different states of the game.
##
## A class that manages the different states of the game.
##

## Signal for when entering build mode
signal build_mode
signal update_road
## Signal for when having selected a building to build
signal selected_building(building_data)

enum State {
	IDLE,
	SELECTED_BUILDING,
	PLACE_BUILDING,
}

func set_state(new_state: State):
	previous_state = state
	state = new_state

var state: State
var previous_state: State

func _ready() -> void:
	set_state(State.IDLE)
