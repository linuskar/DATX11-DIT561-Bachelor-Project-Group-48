extends Node

## The currently selected building
var selected: SelectableBuilding = null


func _on_building_selected(building: SelectableBuilding) -> void:
	if self.selected == null:
		self.selected = building
	else:
		self.selected.unselected()
		self.selected = building
