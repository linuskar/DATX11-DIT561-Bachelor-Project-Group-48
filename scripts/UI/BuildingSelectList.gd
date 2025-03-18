extends Node

## The currently selected building
var selected: SelectableBuilding = null

## Signal emitted when mouse exits the building list.
## Includes the building that has been selected for building.
signal building_wanted(building: BuildingData)

## Signal emitted when mouse enters the building list
signal build_list_entered

## Function for setting the currently selected building. Alternatively unselects it
## if user tries to select previously selected building.
func _on_building_selected(building: SelectableBuilding) -> void:
	if self.selected == null:
		self.selected = building
	elif self.selected == building:
		self.selected.unselected()
		self.selected = null
	else:
		self.selected.unselected()
		self.selected = building

## Functon to send a signal when mouse is no longer hovering over the building
## select list. This is done to tell the build manager when to make the blueprint visible
func _on_mouse_exited() -> void:
	if not selected == null:
		building_wanted.emit(selected.get_building_data())

## Function to send a signal when mouse starts hovering over the building select
## list. This is done to tell the build manager when to make the blueprint invisible
func _on_mouse_entered() -> void:
	if not selected == null:
		build_list_entered.emit()


func _on_open_build_list() -> void:
	self.find_child("List").visible = not self.find_child("List").visible
