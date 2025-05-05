class_name BuildingInfo extends UIMenu

@onready var image: TextureRect = $MarginContainer/General/VBoxContainer/MarginContainer/SingleSelected/MarginContainer3/FactoryImage
@onready var building_name: Label = $MarginContainer/General/VBoxContainer/MarginContainer/SingleSelected/BuildingName
@onready var info: Label = $MarginContainer/General/VBoxContainer/MarginContainer/SingleSelected/MarginContainer4/PanelContainer/MarginContainer/BuildingInfo
@onready var main_container: MarginContainer = $MarginContainer
@onready var storage_list: VBoxContainer = $MarginContainer/Storage/MarginContainer/VBoxContainer/StoredResources
@onready var sell_value_label: Label = $MarginContainer/Storage/MarginContainer/VBoxContainer/MarginContainer/Control/SellValue
@onready var sell_store_status_label: Label = $MarginContainer/Selling/MarginContainer/VBoxContainer/MarginContainer/CurrentlySelling
@onready var general_tab: ScrollContainer = $MarginContainer/General
@onready var storage_tab: ScrollContainer = $MarginContainer/Storage
@onready var mode_tab: ScrollContainer = $MarginContainer/Selling
@onready var tab_bar: TabBar = $TabBar

## The currently selected buildings
var selected_buildings: Array[Building]

## Template scene for a stored resource panel
var stored_resource_panel: PackedScene = preload("res://scenes/UI/stored_resource.tscn")

## The single selected panel
@onready var single_select: VBoxContainer = $MarginContainer/General/VBoxContainer/MarginContainer/SingleSelected
## The multiselect panel
@onready var multi_select: VBoxContainer = $MarginContainer/General/VBoxContainer/MarginContainer/MultiSelected
## Template for a panel with number of buildings
var building_numbering: PackedScene = preload("res://scenes/utility/BuildingNumbering.tscn")
## Dictionary containing the numbered buildings
var building_numberings: Dictionary[Enums.BuildingType, BuildingNumbering] = {}

## A dict containing references from a resourcetype to the corresponding
## stored resource panel
var storage_connections: Dictionary[Enums.ResourceType, StoredResourcePanel] = {}

func _ready() -> void:
	super._ready()
	#BuildingSignals.building_clicked.connect(set_active)
	BuildingSelector.buildings_selected.connect(set_active)
	set_inactive()

## Fills the info label with text dependant on the building it recieved
func populate_info_label(building: Building) -> void:
	image.set_texture(building.building_sprite.texture)
	building_name.set_text(Enums.building_type_to_string(building.building_data.building_type))
	info.text = get_text(building.building_data)

func populate_multi_selected(buildings: Array[Building]) -> void:
	for child in multi_select.get_children():
		child.queue_free()
	building_numberings.clear()
	for building in buildings:
		building.building_selected(building)
		if building.building_type in building_numberings.keys():
			building_numberings.get(building.building_type).number_of_buildings += 1
			building_numberings.get(building.building_type).update_text()
		else:
			var new_instance: BuildingNumbering = building_numbering.instantiate()
			building_numberings.set(building.building_type, new_instance)
			building_numberings.get(building.building_type).number_of_buildings = 1
			new_instance.ready_instance(building.building_type, building)
			multi_select.add_child(new_instance)

## Fills the storage panel with stored resources. Also adds the panels
## to the storage connections
func populate_storage_panel() -> void:
	## First clear all children from the storage list and storage connections dict
	storage_connections.clear()
	for child in storage_list.get_children():
		child.queue_free()
	for building in selected_buildings:
		if building is StorageBuilding:
			for resource in building.output_storage.keys():
				if Enums.is_emission(resource):
					continue ## We dont want to display emissions as part of storage
				elif Enums.is_byproduct(resource):
					var stored_amount: int = building.output_storage.get(resource)
					if not storage_connections.has(resource):
						var instance: StoredResourcePanel = stored_resource_panel.instantiate()
						storage_list.add_child(instance)
						instance.ready_instance(resource, stored_amount)
						storage_connections.set(resource, instance)
						instance.disable_selling()
						instance.connect_to_building(building)
					else:
						storage_connections.get(resource).change_resources(resource, stored_amount)
						storage_connections.get(resource).connect_to_building(building)
				else:
					var stored_amount: int = building.output_storage.get(resource)
					if not storage_connections.has(resource):
						var instance: StoredResourcePanel = stored_resource_panel.instantiate()
						storage_list.add_child(instance)
						instance.ready_instance(resource, stored_amount)
						storage_connections.set(resource, instance)
						instance.connect_to_building(building)
						instance.resource_selling_changed.connect(update_sell_amount)
					else:
						storage_connections.get(resource).change_resources(resource, stored_amount)
						storage_connections.get(resource).connect_to_building(building)
## Formating building data into a string that is then displayed in the
## building info panel.
func get_text(building_data: BuildingData) -> String:
	return building_data.accept(self)

func handle_building(building: BuildingData) -> String:
	var text: String = ""
	text += get_valid_tiles_text(building)
	text += get_upkeep_text(building)
	disable_sell_tab(true)
	return text
	
func handle_storage_building(building: StorageBuildingData) -> String:
	var text: String = ""
	text += handle_building(building)
	text += get_storage_text(building)
	if building.building_type in Enums.landfills:
		text += get_connected_landfills(building)
	return text

func handle_prod_building(building: ProductionBuildingData) -> String:
	var text: String = ""
	text += handle_storage_building(building)
	text += get_ouputs_text(building)
	text += get_emissions_text(building)
	text += get_inputs_text(building)
	disable_sell_tab(false)
	return text

func handle_gath_building(building: GatheringBuildingData) -> String:
	var text: String = ""
	text += handle_prod_building(building)
	text += get_resource_node_text(building)
	return text

func handle_areagath_building(building: AreaGatheringBuildingData) -> String:
	var text: String = ""
	text += handle_gath_building(building)
	text += get_gathering_text(building)
	return text
	
func get_upkeep_text(building: BuildingData) -> String:
	var text: String = "\nUpkeep\n"
	text += str(building.building_upkeep) + "\n"
	return text
	
## Adds all the different outputs of the building, if it has any
func get_ouputs_text(building_data: ProductionBuildingData) -> String:
	var text: String = ""
	if building_data.output_generation.keys():
		text += "\nOutputs\n"
		for output in building_data.output_generation.keys():
			if !Enums.is_emission(output):
				text += Enums.resource_type_to_string(output) + ": " + str(building_data.output_generation.get(output)) + "\n"
	return text
	
## Gets text representing what the emissions are for a building, if it has any
func get_emissions_text(building_data: ProductionBuildingData) -> String:
	var text: String = ""
	if Enums.is_a_polluting_building(building_data.building_type):
		text += "\nEmissions\n"
		for output in building_data.output_generation.keys():
			if Enums.is_emission(output):
				text += Enums.resource_type_to_string(output) + ": In an area.\n"
	return text

## Adds all the different inputs of the building, if it has any
func get_inputs_text(building_data: ProductionBuildingData) -> String:
	var text: String = ""
				
	if building_data.input_recipes.keys():
		## If the recipe is empty for a production building
		if building_data.input_recipes.is_empty():
			return ""
			
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
		
		text += "\nInputs\n"
		
		var i: int = 0
		
		for recipe_id in input_recipes.keys():
			if i > 0:
				text += "OR\n"
			var recipe: InputRecipe = input_recipes.get(recipe_id)
			for resource in recipe.resources:
				text += Enums.resource_type_to_string(resource) + ': ' + str(building_data.input_use_rates.get(resource)) + '\n'
			i += 1
	return text
	
## Adds all the tiles considered valid for placement
func get_valid_tiles_text(building_data: BuildingData) -> String:
	var text: String = ""
	text += "\nPlacement\n"
	for tile in building_data.valid_tile_types_to_place_on:
		text += Enums.tile_type_to_string(tile) + '\n'
	return text

## Adds storage capacity to the text
func get_storage_text(building_data: StorageBuildingData) -> String:
	var text: String = ""
	text += "\nMax Storage\n"
	for key in selected_buildings.front().max_storage.keys():
		text += Enums.resource_type_to_string(key) + ': ' + str(selected_buildings.front().max_storage.get(key)) + '\n'
	return text

func get_connected_landfills(building: StorageBuildingData) -> String:

	var text: String = "" 
	
	var main_resource: String = Enums.resource_type_to_string(selected_buildings.front().main_resource)
	var auto_expand_max_capacity_amount: String = str(selected_buildings.front().auto_expand_max_capacity_amount)
	var landfill_type: String = Enums.building_type_to_string(selected_buildings.front().building_type)
	
	text += "\n" + "This building auto expands and shrinks its max capacity of " + main_resource + " by " +  auto_expand_max_capacity_amount + "."+ "\n"
	text += "\nConnected " + landfill_type + "S: " + str(selected_buildings.front().connected_landfills.size() + 1) + '\n'
	return text

## Specific for gathering buildings, add the resource node it has to be placed on for operation
func get_resource_node_text(building_data: GatheringBuildingData) -> String:
	return "\nGathers on resource node: " + Enums.resource_type_to_string(building_data.can_gather_resource_type) + '\n'
	
func get_gathering_text(building_data: AreaGatheringBuildingData) -> String:
	var text: String = "\nGathering\n"
	var resource: String = Enums.resource_type_to_string(building_data.can_gather_resource_type)
	var range_x: String = str(int(building_data.building_size.x) + (2 * building_data.gather_radius))
	var range_y: String = str(int(building_data.building_size.y) + (2 * building_data.gather_radius))
	return text + resource + ": " + range_x + 'x' + range_y + '\n'

func _set_tab_visible(tab_num: int) -> void:
	for child in main_container.get_children():
		child.hide()
	main_container.get_child(tab_num).show()

## Hide the info panel
func set_inactive() -> void:
	for building in selected_buildings:
		BuildingSignals.building_info_closed.emit(building)
	self.hide()

func hide_ui_menu() -> void:
	set_inactive()

## Function that disables or enables the selling tab
## Disables on true, enables on false
func disable_sell_tab(disable_sell_tab: bool) -> void:
	self.find_child("TabBar").set_tab_disabled(2, disable_sell_tab)
	
func set_building_selling(selling: bool) -> void:
	for building in selected_buildings:
		if building is ProductionBuilding:
			building.currently_selling = selling
			building._output_resources()
	if selling:
		sell_store_status_label.text = "Selling"
	else:
		sell_store_status_label.text = "Storing"
		
## Resets the tabs and panels to basic state
## Shows the general tab and panel by default
func reset_tabs() -> void:
	general_tab.show()
	storage_tab.hide()
	mode_tab.hide()
	tab_bar.current_tab = 0

## Executed when pressing the sell button in the storage tab
## Collects the amount to sell for every resource and sells them
func _sell_chosen_resources() -> void:
	for resource_type in storage_connections.keys():
		if not Enums.is_byproduct(resource_type):
			var stored_resource_panel: StoredResourcePanel = storage_connections.get(resource_type)
			var sold_amount: int = stored_resource_panel.resource_to_sell
			var currency_gain: int = Enums.get_value_of_resource(resource_type)*sold_amount
			for building in selected_buildings:
				if sold_amount == 0:
					continue
				if building is StorageBuilding and building.building_data.output_types.has(resource_type):
					var s_building: StorageBuilding = building
					var in_storage: int = s_building.output_storage.get(resource_type)
					if sold_amount > in_storage:
						sold_amount -= in_storage
						building._send_resources(resource_type, in_storage)
						ResourceSignals.add_input_building.emit(building)
					else:
						building._send_resources(resource_type, sold_amount)
						ResourceSignals.add_input_building.emit(building)
			ResourceSignals.use_resource.emit(resource_type, sold_amount)
			PlayerCurrency.add_currency(currency_gain)
			stored_resource_panel.resource_to_sell = 0
			
			#play sound if sell amount is bigger than 0.
			if currency_gain > 0:
				$money_sound_player.play()
				
	sell_value_label.text = "0"
	
func update_sell_amount(resource: Enums.ResourceType, amount: int) -> void:
	var value: int = Enums.get_value_of_resources(resource, amount)
	sell_value_label.set_text(str(int(sell_value_label.text)+value))

func set_active(buildings: Array[Building]) -> void:
	if buildings.is_empty():
		return
	for building in selected_buildings:
		building.building_deselected(building)
	selected_buildings = clean_buildings_list(buildings)
	if selected_buildings.size() == 1:
		selected_buildings.front().building_selected(selected_buildings.front())
		var current_building: Building = selected_buildings.front()
		if current_building is ResearchLab:
			get_tree().root.get_node("Game/UserInterface/ResearchUI").open(selected_buildings.front())
			return
		else:
			single_select.show()
			multi_select.hide()
			reset_tabs()
			self.show()
			populate_info_label(current_building)
			populate_storage_panel()
	elif selected_buildings.size() > 1:
		single_select.hide()
		multi_select.show()
		reset_tabs()
		self.show()
		populate_multi_selected(selected_buildings)
		populate_storage_panel()

func clean_buildings_list(buildings: Array[Building]) -> Array[Building]:
	var cleaned_list: Dictionary[Building, bool] = {}
	for building in buildings:
		var current: Building = building.get_building()
		if not cleaned_list.has(building):
			cleaned_list.set(current, true)
	return cleaned_list.keys()
