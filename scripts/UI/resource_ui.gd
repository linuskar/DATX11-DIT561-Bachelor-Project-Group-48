extends Panel

var resource_labels = {}

func _ready():
	# Setup references to each resource label
	resource_labels[Enums.ResourceType.WOOD] = $HBoxContainer/Wood/Label
	resource_labels[Enums.ResourceType.COAL] = $HBoxContainer/Coal/Label

	# Connect to the global signal
	ResourceSignals.update_UI.connect(_on_update_UI)

func _on_update_UI(resource_type: Enums.ResourceType, amount: int) -> void:
	if resource_type in resource_labels:
		resource_labels[resource_type].text = str(amount)
