extends Control

var resource_labels = {}
var resource_nodes = {}
var first_resource = false

func _ready():
	# References to each resource node and its label
	resource_nodes[Enums.ResourceType.WOOD] = $MarginContainer/HBoxContainer/Wood
	resource_labels[Enums.ResourceType.WOOD] = $MarginContainer/HBoxContainer/Wood/Label

	resource_nodes[Enums.ResourceType.COAL] = $MarginContainer/HBoxContainer/Coal
	resource_labels[Enums.ResourceType.COAL] = $MarginContainer/HBoxContainer/Coal/Label

	resource_nodes[Enums.ResourceType.IRON_ORE] = $MarginContainer/HBoxContainer/Iron_Ore
	resource_labels[Enums.ResourceType.IRON_ORE] = $MarginContainer/HBoxContainer/Iron_Ore/Label
	
	resource_nodes[Enums.ResourceType.BIOMASS] = $MarginContainer/HBoxContainer/Biomass
	resource_labels[Enums.ResourceType.BIOMASS] = $MarginContainer/HBoxContainer/Biomass/Label
	
	resource_nodes[Enums.ResourceType.ELECTRICITY] = $MarginContainer/HBoxContainer/Electricity
	resource_labels[Enums.ResourceType.ELECTRICITY] = $MarginContainer/HBoxContainer/Electricity/Label
	
	#Entire UI, and all of the children are hidden in the begining when no resources have been collected
	visible = false
	for node in resource_nodes.values():
		node.visible = false
	
	# Connect to global signal
	ResourceSignals.update_UI.connect(_on_update_UI)

func _on_update_UI(resource_type: Enums.ResourceType, amount: int) -> void:
	if resource_type in resource_labels:
		#First time collecting a resource, make UI visable
		if not first_resource and amount > 0:
			visible = true
			first_resource = true
		
		# Reveal resource UI if hidden and first time gathered
		if not resource_nodes[resource_type].visible and amount > 0:
			resource_nodes[resource_type].visible = true

		# Update resource amount
		resource_labels[resource_type].text = str(amount)

func _unhandled_input(event: InputEvent) -> void:
	#Toggle UI, only possible after the first resource has been collected.
	if event is InputEventKey and event.pressed and event.keycode == KEY_TAB and first_resource:
		visible = not visible
