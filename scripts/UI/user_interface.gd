extends CanvasLayer

signal build_list_entered

signal ui_status(status: bool)

signal building_wanted(building: BuildingData)

var hovered_references: Dictionary[UIElement, int] = {}
@onready var building_info: BuildingInfo = $BuildingInfo

func _ready() -> void:
	building_info.closed_building_info.connect(_on_building_info_closed)

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

func _on_building_info_closed(building: Building) -> void:
	BuildingSignals.building_info_closed.emit(building)
