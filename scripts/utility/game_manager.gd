extends Node
## A class that manages the game
##
## A class that manages the main functions of the game
##

## The control node for the building selection
func _input(event) -> void:
	if event.is_action_pressed("build"):
		match StateManager.state:
			StateManager.State.IDLE:
				StateManager.set_state(StateManager.State.SELECTED_BUILDING)
			StateManager.State.SELECTED_BUILDING:
				StateManager.set_state(StateManager.State.IDLE)
			StateManager.State.PLACE_BUILDING:
				StateManager.set_state(StateManager.State.IDLE)
		StateManager.build_mode.emit()
