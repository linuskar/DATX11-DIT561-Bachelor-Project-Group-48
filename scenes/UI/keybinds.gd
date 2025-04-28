extends Button



func _on_button_down() -> void:
	GameStateManager.show_keybinds.emit(true)
