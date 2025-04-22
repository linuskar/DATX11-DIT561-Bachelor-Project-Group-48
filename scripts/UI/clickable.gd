class_name Clickable
extends TextureButton

var building: Building = null

func _on_button_down() -> void:
	if building != null:
		BuildingSignals.building_clicked.emit(building)
	else:
		BuildingSignals.building_clicked.emit(self.get_parent())
