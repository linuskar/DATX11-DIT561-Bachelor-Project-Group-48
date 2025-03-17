extends Node

## The currently selected building
var selected: SelectableBuilding = null

signal building_wanted(building: BuildingData)

signal build_list_entered

func _on_building_selected(building: SelectableBuilding) -> void:
	if self.selected == null:
		self.selected = building
	elif self.selected == building:
		self.selected.unselected()
		self.selected = null
	else:
		self.selected.unselected()
		self.selected = building


func _on_mouse_exited() -> void:
	if not selected == null:
		building_wanted.emit(selected.get_building_data())


func _on_mouse_entered() -> void:
	if not selected == null:
		build_list_entered.emit()
