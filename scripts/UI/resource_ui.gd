extends UIElement

@export var resources: Dictionary[Enums.ResourceType, Texture] = {}
var resource_labels: Dictionary[Enums.ResourceType, Label] = {}
var resource_nodes: Dictionary[Enums.ResourceType, VBoxContainer] = {}
var resource_rows: Dictionary[Enums.ResourceType, int] = {}
var first_resource: bool = false
var resource_entry: Resource = preload("res://scenes/UI/ResourceUIEntry.tscn")
var hbox_list: Array[HBoxContainer] = []
@export var menu_size: float = 0.45
@export var lerp_speed: float = 0.2
@onready var hbox_resource_container: HBoxContainer = $MarginContainer/VBoxContainer/HBoxContainer
@onready var v_box_container: VBoxContainer = $MarginContainer/VBoxContainer
@onready var arrow_label: Label = $ExpandButton/ArrowLabel
@onready var background_panel: Panel = $BackgroundPanel

var _popped_up: bool = true
var _up_anchor: Vector2 = Vector2(1 - menu_size, 1)
var _down_anchor: Vector2 = Vector2(1, 1 + menu_size)
var _target_anchor: Vector2 = _down_anchor
const max_entries_at_x: int = 9

@onready var expand_button: Button = $ExpandButton
var grid_size: int = 32
func _ready():
	super._ready()
	var current_list_index: int = 0
	var resources_amount_in_container: int = 0
	hbox_list.append(hbox_resource_container)
	
	#for resource in resources.keys():
	#	var new_entry: ResourceUIEntry = resource_entry.instantiate()
	#	new_entry.resource_type = resource
	#	new_entry.texture_to_load = resources.get(resource)
		#new_entry.hide()
	#	resource_nodes.set(resource, new_entry)
	#	hbox_list[current_list_index].add_child(new_entry)
	#	resource_rows.set(resource, current_list_index)
	#	resources_amount_in_container += 1
		
	#	if resources_amount_in_container >= max_entries_at_x:
		#	current_list_index += 1
			# var hbox_container: HBoxContainer = hbox_container_to_duplicate.duplicate()
			#hbox_container.position.y += grid_size*2
		#	resources_amount_in_container = 0
			#v_box_container.add_child(hbox_container)
			#hbox_list.append(hbox_container)
			
	#for i in range(hbox_list.size()):
	#	if i > 0:
		#	hbox_list[i].hide()
	
	#Entire UI, and all of the children are hidden in the begining when no resources have been collected
	# visible = false
	# Note: Gets null instance, the visibility is set in the scene editor
	# for node in resource_nodes.values():
		# node.visible = false
	expand_button.pressed.connect(_on_expand_button_pressed)
	
	# Connect to global signal
	ResourceSignals.update_UI.connect(_on_update_UI)

# func _process(delta):
	# anchor_top = lerp(anchor_top, _target_anchor.x, lerp_speed)
	# anchor_bottom = lerp(anchor_bottom, _target_anchor.y, lerp_speed)

func _on_expand_button_pressed():		
	if !_popped_up:
		var rows: int = 1
		
		for i in range(hbox_list.size()):
			if i > 0:
				hbox_list[i].hide()
			rows += 1
			
		_target_anchor = _down_anchor
		arrow_label.text = "<"
		background_panel.size.y -= 32*rows
	else:
		var rows: int = 1
		
		for i in range(hbox_list.size()):
			if i > 0:
				hbox_list[i].show()
			rows += 1
			
		_target_anchor = _up_anchor
		arrow_label.text = ">"
		background_panel.size.y += 32*rows
	_popped_up = !_popped_up

# func update_resources_list
func update_ui_list(resource: Enums.ResourceType) -> ResourceUIEntry:
	var hbox_container_to_duplicate: HBoxContainer = hbox_resource_container.duplicate()
	v_box_container.add_child(hbox_container_to_duplicate)
	var current_list_index: int = hbox_list.size() - 1
	var new_entry: ResourceUIEntry = resource_entry.instantiate()
	new_entry.resource_type = resource
	new_entry.texture_to_load = resources.get(resource)
	resource_nodes.set(resource, new_entry)
	hbox_list[current_list_index].add_child(new_entry)
	resource_rows.set(resource, current_list_index)
	var resources_amount_in_container: int = hbox_list[current_list_index].get_child_count()
	resources_amount_in_container += 1
	
	if resources_amount_in_container >= max_entries_at_x:
		current_list_index += 1
		var hbox_container: HBoxContainer = hbox_container_to_duplicate.duplicate()
		if current_list_index > 0:
			hbox_container.position.y += grid_size*2
		resources_amount_in_container = 0
		v_box_container.add_child(hbox_container)
		hbox_list.append(hbox_container)
	return new_entry
func _on_update_UI(resource_type: Enums.ResourceType, amount: int) -> void:
	if resource_type in resources:
		#if resource_rows.has(resource_type):
			#var row: int = resource_rows.get(resource_type)
		
		if hbox_list.size() > 0:
			expand_button.show()
		
		var current_node: ResourceUIEntry = resource_nodes.get(resource_type)
		if current_node == null:
			current_node = update_ui_list(resource_type) 
		# Reveal resource UI if hidden and first time gathered
		#if not current_node.visible and amount > 0:
			# current_node.show()
		
		# Update resource amount
		current_node.label.text = str(amount)
