class_name SelectableBuilding extends Control

## Path pointing to the icon representing the building
@export_file() var icon_path

## The building to be placed when clicking the selectable
@export var building: Node2D

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
	self.get_child(0).mouse_filter = MOUSE_FILTER_IGNORE
	
	## Set the image of the factory to the path 
	self.get_child(1).get_child(0).set_texture(load(icon_path))
	
	## Set the text of the main panel according to the template
	set_panel_text()

func _on_main_panel_mouse_entered() -> void:
	self.get_child(0).visible = true
	self.get_child(0).mouse_filter = MOUSE_FILTER_STOP


func _on_main_panel_mouse_exited() -> void:
	self.get_child(0).visible = false
	self.get_child(0).mouse_filter = MOUSE_FILTER_IGNORE
	
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
