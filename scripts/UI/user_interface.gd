class_name UserInterface
extends CanvasLayer

signal building_wanted(building: BuildingData)

static var hovered_references: Dictionary[UIElement, int] = {}
@onready var building_info: BuildingInfo = $BuildingInfo
@onready var panel_container: UIElement = $PanelContainer

func _process(delta: float) -> void:
	ZoomHandler.allow_zoom.emit(hovered_references.is_empty())

func _on_building_select_list_building_wanted(building: BuildingData) -> void:
	building_wanted.emit(building)

func remove_reference(ui_element: UIElement) -> void:
	hovered_references.erase(ui_element)

func add_reference(ui_element: UIElement) -> void:
	hovered_references.set(ui_element, 0)


func _on_ready() -> void:
	for child in self.get_children():
		if child is UIMenu:
			child.self_entered.connect(add_reference)
			child.self_exited.connect(remove_reference)
