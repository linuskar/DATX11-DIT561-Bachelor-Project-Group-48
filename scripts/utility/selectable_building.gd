class_name SelectableBuilding extends Control

## Path pointing to the icon representing the building
@export_file() var icon_path

## Path to the scene of the building to be placed when clicking the selectable
@export_file() var building_path

var building_scene

## The cost of the building
@export var cost: int

## Variable for checking whether the mouse is hovering over the buy button
var hovering_buy: bool = false

## The name of the building
@export var building_name: String

## The list of names and amounts of inputs to the building
@export var inputs: Dictionary[String, int]

## The list of resources that can be contributed to lower cost
@export var contributables: Dictionary[String, int]

## The list of resources that are required to place the building
@export var required: Dictionary[String, int]

func _ready() -> void:
	## Load the building from the building path to the variable
	building_scene = load(building_path)
	
	## Set the image of the factory to the path 
	self.find_child("BuildingIcon").set_texture(load(icon_path))
	
	## Set the text of the main panel according to the template
	set_panel_text()

## Handling signal for pressing the left mouse button
func _input(event: InputEvent) -> void:
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT:
		if hovering_buy:
			var instance = building_scene.instantiate()
			add_child(instance)

## Function that sets the text of the info panel using subfunctions
func set_panel_text() -> void:
	self.find_child("InfoText").clear()
	
	## Begin with the name of the building
	var panel_text: String = "[font_size={10}][color=black]" + building_name + '\n'
	panel_text += add_dict_to_panel(inputs, "Inputs")
	panel_text += add_dict_to_panel(contributables, "Contributables")
	panel_text += add_dict_to_panel(required, "Required")
	panel_text += "[/color][/font_size]"
	self.find_child("InfoText").append_text(panel_text)

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


func _on_buy_mouse_entered() -> void:
	hovering_buy = true


func _on_buy_mouse_exited() -> void:
	hovering_buy = false
