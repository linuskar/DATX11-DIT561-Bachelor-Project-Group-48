extends Node
## A class that manages the game
##
## A class that manages the main functions of the game
##

## The control node for the building selection
@onready var building_selector_control: Control = $Control

func _input(event) -> void:
	if event.is_action_pressed("build"):
		match StateManager.state:
			StateManager.State.IDLE:
				StateManager.set_state(StateManager.State.PLACE_BUILDING)
			StateManager.State.PLACE_BUILDING:
				StateManager.set_state(StateManager.State.IDLE)
				
		StateManager.build_mode.emit()
	
	if event.is_action_pressed("select_building"):
		building_selector_control.visible = !building_selector_control.visible
