extends UIMenu

@onready var buildings: PanelContainer = $PanelContainer/ScrollContainer/BuildingsContainer
@onready var tabs: TabBar = $TabBar

## Function for setting the corresponding list visible
func _set_tab_visible(tab_num: int) -> void:
	for child in buildings.get_children():
		child.hide()
	buildings.get_child(tab_num).show()
