extends Node
## A class that manages the game
##
## A class that manages the main functions of the game
##

## The control node for the building selection
@onready var building_selector: Control = $"../BuildingSelector"

func _ready() -> void:
	StateManager.selected_building.connect(_change_in_selected_building)

func _change_in_selected_building(building_data) ->  void:
	StateManager.set_state(StateManager.State.SELECTED_BUILDING)

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
	
	if event.is_action_pressed("select_building"):
		building_selector.visible = !building_selector.visible
