class_name BuildingInfo extends UIElement

@onready var image: TextureRect = $MarginContainer/General/VBoxContainer/MarginContainer3/FactoryImage
@onready var building_name: Label = $MarginContainer/General/VBoxContainer/BuildingName
@onready var info: Label = $MarginContainer/General/VBoxContainer/MarginContainer4/PanelContainer/MarginContainer/BuildingInfo
@onready var main_container: MarginContainer = $MarginContainer
@onready var storage_list: VBoxContainer = $MarginContainer/Storage/MarginContainer/VBoxContainer/StoredResources
@onready var sell_value_label: Label = $MarginContainer/Storage/MarginContainer/VBoxContainer/MarginContainer/Control/SellValue
@onready var sell_store_status_label: Label = $MarginContainer/Selling/MarginContainer/VBoxContainer/MarginContainer/CurrentlySelling
@onready var general_tab: ScrollContainer = $MarginContainer/General
@onready var storage_tab: ScrollContainer = $MarginContainer/Storage
@onready var mode_tab: ScrollContainer = $MarginContainer/Selling
@onready var tab_bar: TabBar = $TabBar



## The currently held building
var current_building: Building

## Template scene for a stored resource panel
var stored_resource_panel: PackedScene = preload("res://scenes/UI/stored_resource.tscn")

## A dict containing references from a resourcetype to the corresponding
## stored resource panel
var storage_connections: Dictionary[Enums.ResourceType, StoredResourcePanel] = {}

func _ready() -> void:
	super._ready()
	BuildingSignals.building_clicked.connect(set_active)
	set_inactive()

func _process(delta: float) -> void:
	update_storage()

## Updates the storage panel
func update_storage() -> void:
	if current_building is StorageBuilding:
		sell_value_label.text = "0"
		for resource in storage_connections.keys():
			var stored_resources: int = current_building.output_storage.get(resource)
			storage_connections.get(resource).resource_held = stored_resources
			if not Enums.is_byproduct(resource):
				update_sell_amount(resource, storage_connections.get(resource).resource_to_sell)
		

## Fills the info label with text dependant on the building it recieved
func populate_info_label(building: Building) -> void:
	image.set_texture(building.building_sprite.texture)
	building_name.set_text(Enums.building_type_to_string(building.building_data.building_type))
	info.text = get_text(building.building_data)

## Fills the storage panel with stored resources. Also adds the panels
## to the storage connections
func populate_storage_panel(building: StorageBuilding) -> void:
	## First clear all children from the storage list and storage connections dict
	storage_connections.clear()
	for child in storage_list.get_children():
		child.queue_free()
	for resource in building.output_storage.keys():
		if Enums.is_emission(resource):
			pass ## We dont want to display emissions as part of storage
		elif Enums.is_byproduct(resource):
			var stored_amount: int = building.output_storage.get(resource)
			var instance: StoredResourcePanel = stored_resource_panel.instantiate()
			storage_list.add_child(instance)
			instance.ready_instance(resource, stored_amount)
			storage_connections.set(resource, instance)
			instance.disable_selling()
		else:
			var stored_amount: int = building.output_storage.get(resource)
			var instance: StoredResourcePanel = stored_resource_panel.instantiate()
			storage_list.add_child(instance)
			instance.ready_instance(resource, stored_amount)
			storage_connections.set(resource, instance)
			instance.resource_held_changed.connect(update_sell_amount)

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
	return text
	
func handle_prod_building(building: ProductionBuildingData) -> String:
	var text: String = ""
	text += handle_storage_building(building)
	text += get_ouputs_text(building)
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
		for key in building_data.output_generation.keys():
			text += Enums.resource_type_to_string(key) + ': ' + str(building_data.output_generation.get(key)) + '\n'
	return text

## Adds all the different inputs of the building, if it has any
func get_inputs_text(building_data: ProductionBuildingData) -> String:
	var text: String = ""
	if building_data.input_use_rates.keys():
		text += "\nInputs\n"
		for key in building_data.input_use_rates.keys():
			text += Enums.resource_type_to_string(key) + ': ' + str(building_data.input_use_rates.get(key)) + '\n'
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
	text += "\nStorage\n"
	for key in building_data.max_storage.keys():
		text += Enums.resource_type_to_string(key) + ': ' + str(building_data.max_storage.get(key)) + '\n'
	return text

## Specific for gathering buildings, add the resource node it has to be placed on for operation
func get_resource_node_text(building_data: GatheringBuildingData) -> String:
	return "\nGathers on resource node: " + Enums.resource_type_to_string(building_data.can_gather_resource_type) + '\n'

## Gets text representing a building pollution outputs, if it has any
func get_pollution_text(building_data: ProductionBuildingData) -> String:
	if Enums.is_a_polluting_building(building_data.building_type):
		var text: String = "\nPollution\n"
		for output in building_data.output_generation.keys():
			if Enums.is_emission(output):
				text += building_data.output_generation.get(output) + ": In an area.\n"
		return text
	return ""
	
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
	self.hide()

## Show the info panel and update its information
func set_active(building: Building) -> void:
	current_building = building
	reset_tabs()
	self.show()
	populate_info_label(building)
	if current_building is StorageBuilding:
		populate_storage_panel(current_building)
	if current_building is ProductionBuilding:
		set_building_selling(current_building.currently_selling)

## Function that disables or enables the selling tab
## Disables on true, enables on false
func disable_sell_tab(disable_sell_tab: bool) -> void:
	self.find_child("TabBar").set_tab_disabled(2, disable_sell_tab)
	
func set_building_selling(selling: bool) -> void:
	current_building.currently_selling = selling
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
			var stored_amount: int = current_building.output_storage.get(resource_type)
			
			current_building._send_resources(resource_type, sold_amount)
			PlayerCurrency.add_currency(currency_gain)
			stored_resource_panel.resource_to_sell = 0
			ResourceSignals.use_resource.emit(resource_type, sold_amount)
			
	sell_value_label.text = "0"
	if current_building is ProductionBuilding:
		current_building.building_should_operate()
	
func update_sell_amount(resource: Enums.ResourceType, amount: int) -> void:
	var value: int = Enums.get_value_of_resources(resource, amount)
	sell_value_label.set_text(str(int(sell_value_label.text)+value))
