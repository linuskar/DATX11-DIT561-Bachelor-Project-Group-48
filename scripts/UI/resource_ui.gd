extends UIElement

var resource_labels: Dictionary[Enums.ResourceType, Label] = {}
var resource_nodes: Dictionary[Enums.ResourceType, VBoxContainer] = {}
var first_resource: bool = false

func _ready():
	super._ready()
	
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
	# Note: Gets null instance, the visibility is set in the scene editor
	# for node in resource_nodes.values():
		# node.visible = false
	
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
