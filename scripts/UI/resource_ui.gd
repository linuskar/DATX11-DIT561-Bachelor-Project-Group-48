extends UIElement

@export var resources: Dictionary[Enums.ResourceType, Texture] = {}
var resource_labels: Dictionary[Enums.ResourceType, Label] = {}
var resource_nodes: Dictionary[Enums.ResourceType, VBoxContainer] = {}
var resource_rows: Dictionary[Enums.ResourceType, int] = {}
var first_resource: bool = false
var resource_entry: Resource = preload("res://scenes/UI/ResourceUIEntry.tscn")
var _popped_up: bool = true
var grid_size: int = 32
var rows: int = 3
var v_seperation: int = 10
@onready var background_panel: Panel = $BackgroundPanel
@onready var arrow_label: Label = $ExpandButton/ArrowLabel
@onready var h_flow_container: HFlowContainer = $MarginContainer/HFlowContainer
@onready var expand_button: Button = $ExpandButton

func _ready():
	super._ready()
	h_flow_container.add_theme_constant_override("v_separation", v_seperation)
	for resource in resources.keys():
		var new_entry: ResourceUIEntry = resource_entry.instantiate()
		new_entry.resource_type = resource
		new_entry.texture_to_load = resources.get(resource)
		new_entry.hide()
		resource_nodes.set(resource, new_entry)
		h_flow_container.add_child(new_entry)

	expand_button.pressed.connect(_on_expand_button_pressed)
	
	# Connect to global signal
	ResourceSignals.update_UI.connect(_on_update_UI)

func _on_expand_button_pressed():
	if !_popped_up:
		arrow_label.text = "<"
		background_panel.size.y -= grid_size * rows + v_seperation * rows
		h_flow_container.size.y -= grid_size * rows + v_seperation * rows
		size.y -= grid_size * rows + v_seperation*rows
	else:
		arrow_label.text = ">"
		background_panel.size.y += grid_size * rows + v_seperation * rows
		h_flow_container.size.y += grid_size * rows + v_seperation * rows
		size.y += grid_size * rows + v_seperation * rows
	_popped_up = !_popped_up

func _on_update_UI(resource_type: Enums.ResourceType, amount: int) -> void:
	if resource_type in resources:
		var current_node: ResourceUIEntry = resource_nodes.get(resource_type)
		
		# Reveal resource UI if hidden and first time gathered
		if not current_node.visible and amount > 0:
			current_node.show()
			
		# Update resource amount
		current_node.label.text = str(amount)
