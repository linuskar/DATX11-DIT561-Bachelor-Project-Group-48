extends Node

## Signal that is emitted or received when the state
## of the game updates.
signal game_state_updated(paused: bool)

## If the 'pause game' button is pressed halt all processes
## default button is tab
func _input(event: InputEvent) -> void:
	if Input.is_action_just_pressed("pause game"):
		game_state_updated.emit(true)
		get_tree().paused = true

func _resume_game() -> void:
	game_state_updated.emit(false)
	get_tree().paused = false
