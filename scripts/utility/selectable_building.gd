class_name SelectableBuilding extends Control

## Path pointing to the icon representing the building
@export_file() var icon_path: String

## Path to the scene of the building to be placed when clicking the selectable
# @export_file() var building_path: String

## The metadata for building that is selected
@export var building_data: BuildingData

## The cost of the building
@export var cost: int

## Variable for checking whether the mouse is hovering over the buy button
var hovering_buy: bool = false

## The name of the building
var building_name: String

## The list of names and amounts for max storage of resources to the building
var max_storage: Dictionary[String, int]

## The list of names and amounts of inputs to the building
var inputs: Dictionary[String, int]

## The list of names and amounts of outputs to the building
var outputs: Dictionary[String, int]

## The list of resources that can be contributed to lower cost
@export var contributables: Dictionary[String, int]

## The list of resources that are required to place the building
@export var required: Dictionary[String, int]

func _ready() -> void:
	building_name = Enums.building_type_to_string(building_data.building_type)
	
	init_resource_data(max_storage, building_data.max_storage)
	init_resource_data(outputs, building_data.output_generation)
	init_resource_data(inputs, building_data.input_use_rates)
	
	## Set the image of the factory to the path 
	self.find_child("BuildingIcon").set_texture(load(icon_path))
		
	## Set the name and cost of the building
	self.find_child("BuildingNameCost").set_text(building_name + ": " + str(cost))
	
	## Set the text of the main panel according to the template
	set_panel_text()
	
## Initialize the metadata for resources related to a building
## and convert them into strings 
func init_resource_data(string_data: Dictionary[String, int], data: Dictionary[Enums.ResourceType, int]) -> void:
	for resource in data.keys():
		var resource_string: String = Enums.resource_type_to_string(resource)
		var input_needed: int = data.get(resource)
		string_data.set(resource_string, input_needed)
		
## Handling signal for pressing the left mouse button
func _input(event: InputEvent) -> void:
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT:
		if hovering_buy:
			pass
			## TODO: fix with placing building when selecting in GUI
			# var instance = building_scene.instantiate()
			# var
			# add_child(instance)

## Function that sets the text of the info panel using subfunctions
func set_panel_text() -> void:
	self.find_child("InfoText").clear()
	
	## Begin with the name of the building
	var panel_text: String = "[font_size={10}][color=black]" + building_name + '\n'
	panel_text += add_dict_to_panel(inputs, "Inputs")
	panel_text += add_dict_to_panel(outputs, "Outputs")
	panel_text += add_dict_to_panel(max_storage, "Max Storage")
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

## When the mouse hovers over the buy label set hovering_buy to true
func _on_buy_mouse_entered() -> void:
	hovering_buy = true

## When the mouse stops hovering over the buy label set hovering_buy to false
func _on_buy_mouse_exited() -> void:
	hovering_buy = false
