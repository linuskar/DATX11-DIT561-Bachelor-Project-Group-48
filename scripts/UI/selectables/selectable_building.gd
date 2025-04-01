class_name SelectableBuilding 
extends Control

## Path pointing to the icon representing the building
@export_file() var icon_path: String

## The metadata for building that is selected
@export var building_data: BuildingData

## Signal to be emitted when this building is selected. 
## Emitted together with the building itself.
signal selected(building: SelectableBuilding)

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
	self.find_child("Containers").find_child("MarginContainer").find_child("BuildingIcon").set_texture(load(icon_path))
		
	## Set the name and cost of the building
	self.find_child("BuildingNameCost").set_text(building_name + ": " + str(building_data.building_cost))
	
	## Set the text of the main panel according to the template
	set_panel_text()
	
## Initialize the variables for resource metadata related to a building
## and convert them into strings 
func init_resource_data(string_data: Dictionary[String, int], data: Dictionary[Enums.ResourceType, int]) -> void:
	for resource in data.keys():
		var resource_string: String = Enums.resource_type_to_string(resource)
		var input_needed: int = data.get(resource)
		string_data.set(resource_string, input_needed)
		
func _input(event: InputEvent) -> void:
	## Handling press of left mouse button for selecting a building to buy
	## and then place after
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
		if hovering_buy:
			accept_event()
			StateManager.selected_building.emit(building_data)

## Function that sets the text of the info panel using subfunctions
func set_panel_text() -> void:
	self.find_child("TextContainer").find_child("InfoText").text = ''
	
	## Begin with the name of the building
	var panel_text: String = building_name + '\n'
	panel_text += add_dict_to_panel(inputs, "Inputs")
	panel_text += add_dict_to_panel(outputs, "Outputs")
	panel_text += add_dict_to_panel(max_storage, "Max Storage")
	panel_text += add_dict_to_panel(contributables, "Contributables")
	panel_text += add_dict_to_panel(required, "Required")
	self.find_child("TextContainer").find_child("InfoText").text = panel_text

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

## Sets this building into its 'selected' styling
func _on_selected() -> void:
	self.find_child("MainBox").visible = false
	self.find_child("Selected").visible = true
	emit_signal("selected", self)

## Sets this building to its 'unselected' styling
func unselected() -> void:
	self.find_child("MainBox").visible = true
	self.find_child("Selected").visible = false
	

func get_building_data() -> BuildingData:
	return self.building_data
