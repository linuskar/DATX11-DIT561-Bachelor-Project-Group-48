class_name BuildingInfo extends Control

@onready var image = $MarginContainer/General/VBoxContainer/MarginContainer3/FactoryImage
@onready var building_name = $MarginContainer/General/VBoxContainer/BuildingName
@onready var info = $MarginContainer/General/VBoxContainer/MarginContainer4/PanelContainer/MarginContainer/BuildingInfo
@onready var main_container: MarginContainer = $MarginContainer
@onready var storage_list: VBoxContainer = $MarginContainer/Storage/MarginContainer/VBoxContainer/StoredResources

## The currently held building
var current_building

## Template scene for a stored resource panel
var stored_resource_panel: PackedScene = preload("res://scenes/UI/stored_resource.tscn")

## A dict containing references from a resourcetype to the corresponding
## stored resource panel
var storage_connections: Dictionary[Enums.ResourceType, StoredResourcePanel] = {}

func _ready() -> void:
	BuildingSignals.building_clicked.connect(set_active)
	set_inactive()

func _process(delta: float) -> void:
	update_storage()

## Updates the storage panel
func update_storage() -> void:
	if current_building is StorageBuilding:
		for resource in storage_connections.keys():
			var stored_resources: int = current_building.output_storage.get(resource)
			storage_connections.get(resource).resource_held = stored_resources
		

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
		if !Enums.is_byproduct(resource) and !Enums.is_emission(resource):
			var stored_amount: int = building.output_storage.get(resource)
			var instance: StoredResourcePanel = stored_resource_panel.instantiate()
			storage_list.add_child(instance)
			instance.ready_instance(resource, stored_amount)
			storage_connections.set(resource, instance)

## Formating building data into a string that is then displayed in the
## building info panel.
func get_text(building_data: BuildingData) -> String:
	return building_data.accept(self)

func handle_building(building: BuildingData) -> String:
	var text: String = ""
	text += get_valid_tiles_text(building)
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
	self.show()
	populate_info_label(building)
	if current_building is StorageBuilding:
		populate_storage_panel(current_building)

## Function that disables or enables the selling tab
## Disables on true, enables on false
func disable_sell_tab(disable_sell_tab: bool) -> void:
	self.find_child("TabBar").set_tab_disabled(2, disable_sell_tab)
	
func set_building_selling() -> void:
	current_building.currently_selling = true
	
func set_building_storing() -> void:
	current_building.currently_selling = false
