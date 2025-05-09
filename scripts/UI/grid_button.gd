extends Button


func _on_toggled(toggled_on: bool) -> void:
	GameStateManager.grid_setting_toggled.emit(toggled_on)
