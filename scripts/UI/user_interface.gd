class_name UserInterface
extends CanvasLayer

signal build_list_entered

signal ui_status(status: bool)

signal building_wanted(building: BuildingData)

static var hovered_references: Dictionary[UIElement, int] = {}
@onready var building_info: BuildingInfo = $BuildingInfo
@onready var panel_container: UIElement = $PanelContainer

func _process(delta: float) -> void:
	ui_status.emit(not hovered_references.is_empty())
	ZoomHandler.allow_zoom.emit(hovered_references.is_empty())

func _on_building_select_list_build_list_entered() -> void:
	build_list_entered.emit() 

func _on_building_select_list_building_wanted(building: BuildingData) -> void:
	building_wanted.emit(building)

func remove_reference(ui_element: UIElement) -> void:
	hovered_references.erase(ui_element)

func add_reference(ui_element: UIElement) -> void:
	hovered_references.set(ui_element, 0)
