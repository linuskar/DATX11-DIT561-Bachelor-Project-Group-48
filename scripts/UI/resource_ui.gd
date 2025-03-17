extends PanelContainer

var resource_labels = {}

func _ready():
	# Setup references to each resource label
	resource_labels[Enums.ResourceType.WOOD] = $MarginContainer/HBoxContainer/Wood/Label
	resource_labels[Enums.ResourceType.COAL] = $MarginContainer/HBoxContainer/Coal/Label
	resource_labels[Enums.ResourceType.IRON_ORE] = $MarginContainer/HBoxContainer/Iron_Ore/Label

	# Connect to the global signal
	ResourceSignals.update_UI.connect(_on_update_UI)

func _on_update_UI(resource_type: Enums.ResourceType, amount: int) -> void:
	if resource_type in resource_labels:
		resource_labels[resource_type].text = str(amount)

func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventKey and event.pressed and event.keycode == KEY_TAB:
		visible = not visible
