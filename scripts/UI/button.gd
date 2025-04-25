extends Button

var ui_element: UIElement = UIElement.new()

func _on_button_up() -> void:
	GameStateManager.game_state_updated.emit(true)
