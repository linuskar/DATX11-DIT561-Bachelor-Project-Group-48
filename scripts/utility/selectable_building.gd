class_name SelectableBuilding extends Control

## Path pointing to the icon representing the building
@export_file() var icon_path

## The building to be placed when clicking the selectable
@export var building: Node2D

## Variable to keep track of whether the mouse is 
## hovering over the selectable
var hovering: bool = false

## Variable to keep track of whether the main panel
## is showing or not
var main_panel_visible: bool = true

## The cost of the building
@export var cost: int

## The name of the building
@export var building_name: String

## The list of names and amounts of inputs to the building
@export var inputs: Dictionary[String, int]

## The list of resources that can be contributed to lower cost
@export var contributables: Dictionary[String, int]

## The list of resources that are required to place the building
@export var required: Dictionary[String, int]

func _ready() -> void:
	
	## Set the hover panel invisible while also making it not catch user inputs
	self.get_child(0).visible = false
	
	## Set the image of the factory to the path 
	self.get_child(1).get_child(0).set_texture(load(icon_path))
	
	## Set the text of the main panel according to the template
	set_panel_text()

func _input(event: InputEvent) -> void:
	if event is InputEventMouseButton and event.is_pressed() and event.button_index == MOUSE_BUTTON_RIGHT:
		if hovering:
			show_info_panel(main_panel_visible)
			main_panel_visible = not main_panel_visible

func show_info_panel(status: bool) -> void:
	if status:
		self.get_child(0).visible = true
		self.get_child(1).visible = false
	else:
		self.get_child(0).visible = false
		self.get_child(1).visible = true

func set_panel_text() -> void:
	self.get_child(0).get_child(0).clear()
	
	## Begin with the name of the building
	var panel_text: String = "[font_size={10}]" + building_name + '\n'
	panel_text += add_dict_to_panel(inputs, "Inputs")
	panel_text += add_dict_to_panel(contributables, "Contributables")
	panel_text += add_dict_to_panel(required, "Required")
	panel_text += "[/font_size]"
	self.get_child(0).get_child(0).append_text(panel_text)

## Function for taking keys from a dictionary and returning 
## a formatted string containing those keys and their values
func add_dict_to_panel(dict: Dictionary[String, int], dict_name: String) -> String:
	var text: String = ""
	if not dict.is_empty():
		text += dict_name + '\n'
		for key in dict.keys():
			text += key + ": " + str(dict.get(key)) + '\n'
		text += '\n'
	return text


func _on_mouse_entered() -> void:
	hovering = true

func _on_mouse_exited() -> void:
	hovering = false
