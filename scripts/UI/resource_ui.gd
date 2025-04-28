extends UIElement

@export var resources: Dictionary[Enums.ResourceType, Texture] = {}
var resource_labels: Dictionary[Enums.ResourceType, Label] = {}
var resource_nodes: Dictionary[Enums.ResourceType, VBoxContainer] = {}
var first_resource: bool = false
@onready var list: HBoxContainer = $MarginContainer/HBoxContainer
var resource_entry: Resource = preload("res://scenes/UI/ResourceUIEntry.tscn")

func _ready():
	super._ready()
	
	for resource in resources.keys():
		var new_entry: ResourceUIEntry = resource_entry.instantiate()
		new_entry.resource_type = resource
		new_entry.texture_to_load = resources.get(resource)
		new_entry.hide()
		resource_nodes.set(resource, new_entry)
		list.add_child(new_entry)
	
	#Entire UI, and all of the children are hidden in the begining when no resources have been collected
	visible = false
	# Note: Gets null instance, the visibility is set in the scene editor
	# for node in resource_nodes.values():
		# node.visible = false
	
	# Connect to global signal
	ResourceSignals.update_UI.connect(_on_update_UI)

func _on_update_UI(resource_type: Enums.ResourceType, amount: int) -> void:
	if resource_type in resources:
		#First time collecting a resource, make UI visable
		if not first_resource and amount > 0:
			visible = true
			first_resource = true
		
		var current_node: ResourceUIEntry = resource_nodes.get(resource_type)
		
		# Reveal resource UI if hidden and first time gathered
		if not current_node.visible and amount > 0:
			current_node.show()

		# Update resource amount
		current_node.label.text = str(amount)
