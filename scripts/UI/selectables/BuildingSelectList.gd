extends UIElement

## The currently selected building
var selected: SelectableBuilding = null

## Signal emitted when mouse exits the building list.
## Includes the building that has been selected for building.
signal building_wanted(building: BuildingData)

## Function for setting the currently selected building. Alternatively unselects it
## if user tries to select previously selected building.
func _on_building_selected(building: SelectableBuilding) -> void:
	if self.selected == null:
		self.selected = building
		building_wanted.emit(selected.get_building_data())
	elif self.selected == building:
		self.selected.unselected()
		self.selected = null
		building_wanted.emit(self.selected)
	else:
		self.selected.unselected()
		self.selected = building
		building_wanted.emit(selected.get_building_data())

func _on_open_build_list() -> void:
	set_state(not self.find_child("List").visible)

## Function that sets the state of the build list.
## true means it is active and false means it is inactive.
func set_state(state: bool) -> void:
	if state:
		self.find_child("List").visible = true
	if not state:
		self.find_child("List").visible = false
