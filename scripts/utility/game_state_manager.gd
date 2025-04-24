extends Node

## Signal that is emitted or received when the state
## of the game updates.
signal game_state_updated(paused: bool)

## Set the script to always update even if the rest of 
## the game is paused.
func _ready() -> void:
	process_mode = Node.PROCESS_MODE_ALWAYS
	game_state_updated.connect(update_game_state)

## If the 'pause game' button is pressed halt all processes
## default button is tab
func _input(event: InputEvent) -> void:
	if Input.is_action_just_pressed("pause game"):
		game_state_updated.emit(not get_tree().paused)

## Updates the state of the game to the given variable
func update_game_state(paused: bool) -> void:
	get_tree().paused = paused

## Unpauses the game
func _resume_game() -> void:
	game_state_updated.emit(false)
	get_tree().paused = false
