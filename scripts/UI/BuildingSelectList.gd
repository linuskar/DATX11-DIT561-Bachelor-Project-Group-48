extends Node

## The currently selected building
var selected: SelectableBuilding = null

signal building_wanted(building: BuildingData)

func _on_building_selected(building: SelectableBuilding) -> void:
	if self.selected == null:
		self.selected = building
	elif self.selected == building:
		self.selected.unselected()
	else:
		self.selected.unselected()
		self.selected = building


func _on_mouse_exited() -> void:
	if not selected == null:
		building_wanted.emit(selected.get_building_data())
