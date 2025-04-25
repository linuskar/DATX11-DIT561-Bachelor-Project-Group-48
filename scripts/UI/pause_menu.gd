extends Control

func _ready() -> void:
	GameStateManager.game_state_updated.connect(update_visibility)

## Function to update the visibility of the pause menu.
## When this function receives 'false' it hides itself,
## it shows itself when receiving 'true'.
func update_visibility(visible: bool) -> void:
	if visible:
		self.show()
	else:
		self.hide()
