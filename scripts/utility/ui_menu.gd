class_name UIMenu extends UIElement

@onready var buildings: PanelContainer = $ScrollContainer/BuildingsContainer
@onready var tabs: TabBar = $TabBar

func _ready() -> void:
	super()
	visibility_changed.connect(_on_menu_visibility_changed)

func _on_menu_visibility_changed() -> void:
	if self.visible:
		GameStateManager.add_menu(self)
	else:
		GameStateManager.remove_menu(self)

## Function to hide UI menu.
## Can be overriden by classes that extend this.
func hide_ui_menu() -> void:
	hide()

## Function for setting the corresponding list visible
func _set_tab_visible(tab_num: int) -> void:
	for child in buildings.get_children():
		child.hide()
	buildings.get_child(tab_num).show()
