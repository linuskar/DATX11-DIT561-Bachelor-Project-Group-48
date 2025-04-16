extends TextureButton

func _on_button_down() -> void:
	BuildingSignals.building_clicked.emit(self.get_parent())
