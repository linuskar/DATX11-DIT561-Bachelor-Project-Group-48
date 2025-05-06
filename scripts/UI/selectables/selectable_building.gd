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

## The text label to be filled with information pertaining to the 
## building
@onready var info_label: Label = $TextContainer/VBoxContainer/InfoText

## Button that causes this selectable to be labeled a selected
@onready var select_button: Button = $SelectButton

func _ready() -> void:
	building_name = Enums.building_type_to_string(building_data.building_type)
	if building_data is StorageBuildingData:
		init_resource_data(max_storage, building_data.max_storage)
	if building_data is ProductionBuildingData:
		init_resource_data(outputs, building_data.output_generation)
		init_resource_data(inputs, building_data.input_use_rates)
	
	## Set the image of the factory to the path 
	self.find_child("Containers").find_child("MarginContainer").find_child("BuildingIcon").set_texture(load(icon_path))
		
	## Set the name and cost of the building
	self.find_child("BuildingNameCost").set_text(building_name + ": " + str(building_data.building_cost))
	
	## Set the text of the main panel according to the template
	set_panel_text()
	ResearchSignals.research_completed.connect(update_panel_text)

## Initialize the variables for resource metadata related to a building
## and convert them into strings 
func init_resource_data(string_data: Dictionary[String, int], data: Dictionary[Enums.ResourceType, int]) -> void:
	for resource in data.keys():
		var resource_string: String = Enums.resource_type_to_string(resource)
		var resource_needed: int = data.get(resource)
		string_data.set(resource_string, resource_needed)

func update_panel_text(research_data: ResearchData) -> void:
	set_panel_text()
		
func _input(event: InputEvent) -> void:
	## Handling press of left mouse button for selecting a building to buy
	## and then place after
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
		if hovering_buy:
			accept_event()
			StateManager.selected_building.emit(building_data)

## Function that sets the text of the info panel using subfunctions
func set_panel_text() -> void:
	info_label.text = ''
	
	## Begin with the name of the building
	var panel_text: String = building_name + '\n'
	
	panel_text += get_inputs()
	panel_text += "\nUpkeep\n" + str(building_data.building_upkeep) + "\n"
	panel_text += add_dict_to_panel(outputs, "Outputs")
	panel_text += add_dict_to_panel(max_storage, "Max Storage")
	panel_text += add_dict_to_panel(contributables, "Contributables")
	panel_text += add_dict_to_panel(required, "Required")
	info_label.text = panel_text

func get_inputs() -> String:
	if building_data is ProductionBuildingData:
		if building_data.input_recipes.keys():
			## If the recipe is empty for a production building
			if building_data.input_recipes.get(0).is_empty():
				return ""
				
			var text: String = "\nInputs\n"
			var input_recipes: Dictionary[int, InputRecipe] = {}
			
			for id in building_data.input_recipes.keys():
				var recipe: Array = building_data.input_recipes.get(id)
				
				for resource_type in recipe:
					if input_recipes.has(id):
						var input_recipe: InputRecipe = input_recipes.get(id)
						input_recipe.resources.append(resource_type)
						input_recipes.set(id, input_recipe)
					else:
						var new_array: InputRecipe = InputRecipe.new()
						new_array.resources.append(resource_type)
						input_recipes.set(id, new_array)
			
			var i: int = 0
			
			for recipe_id in input_recipes.keys():
				if i > 0:
					text += "OR\n"
				var recipe: InputRecipe = input_recipes.get(recipe_id)
				for resource in recipe.resources:
					text += Enums.resource_type_to_string(resource) + ': ' + str(building_data.input_use_rates.get(resource)) + '\n'
				i += 1
			return text
	return add_dict_to_panel(inputs, "Inputs")

## Function for taking keys from a dictionary and returning 
## a formatted string containing those keys and their values
func add_dict_to_panel(dict: Dictionary[String, int], dict_name: String) -> String:
	var text: String = ""
	if not dict.is_empty():
		text += dict_name + '\n'
		for key in dict.keys():
			## Want to hide the number of emissions outputted,
			## maybe note the level like low, medium, high, to get an estimate
			var resource_type: Enums.ResourceType = Enums.string_to_resource_type(key)
			if dict_name == "Outputs" and building_data is AreaGatheringBuildingData and !Enums.is_emission(resource_type):
				var gather_radius: int = building_data.gather_radius
				var size_x: int = building_data.building_size.x
				var size_y: int = building_data.building_size.y
				var area: String = str(size_x + 2 * gather_radius) + "x" + str(size_y + 2 * gather_radius)
				if Enums.is_byproduct(resource_type) and building_data.building_type == Enums.BuildingType.WOOD_CUTTER:
					var byproduct_from_wood: String = str(building_data.output_generation.get(resource_type))
					text += key + ": " + byproduct_from_wood + " per tile." + '\n'
				else:	
					text += key + ": " + area + " area. " + str(dict.get(key)) + " per tile." + '\n'
			elif dict_name == "Outputs" and Enums.is_gathering_building(building_data.building_type) and !Enums.is_emission(resource_type):
				text += key + ": " + str(dict.get(key)) + " per tile." + '\n'
			## Want to hide the number of emissions outputted,
			## maybe note the level like low, medium, high, to get an estimate
			elif dict_name == "Outputs" and Enums.is_a_polluting_building(building_data.building_type) and Enums.is_emission(resource_type):
				text += key + ": In an area." + '\n'
			elif dict_name == "Max Storage" and building_data.building_type == Enums.BuildingType.BIOMASS_LANDFILL:
				text += key + ": " + str(dict.get(key)) + '\n'
				text += "\n" + "This building auto expands and shrinks its max capacity of BIOMASS by " + str(building_data.max_storage.get(Enums.ResourceType.BIOMASS)) + "."+ "\n"
			else:
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
	_set_button_text(false)
	self.find_child("MainBox").visible = true
	self.find_child("Selected").visible = false
	

func get_building_data() -> BuildingData:
	return self.building_data

func _set_button_text(toggled_on: bool) -> void:
	if toggled_on:
		self.select_button.text = "Unselect"
	else:
		self.select_button.text = "Select"
