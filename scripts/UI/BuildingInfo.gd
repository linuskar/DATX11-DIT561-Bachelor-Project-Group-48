extends Control

@onready var image = $ScrollContainer/VBoxContainer/MarginContainer3/FactoryImage
@onready var building_name = $ScrollContainer/VBoxContainer/BuildingName
@onready var info = $ScrollContainer/VBoxContainer/MarginContainer4/PanelContainer/MarginContainer/BuildingInfo

func _ready() -> void:
	BuildingSignals.building_clicked.connect(set_active)
	set_inactive()
	
## Fills the info label with text dependant on the building it recieved
func populate_info_label(building: Building) -> void:
	image.set_texture(building.building_sprite.texture)
	building_name.set_text(Enums.building_type_to_string(building.building_data.building_type))
	info.text = get_text(building.building_data)

## Formating building data into a string that is then displayed in the
## building info panel.
func get_text(building_data: BuildingData) -> String:
	var text: String = ""
	
	## Adds all the different outputs of the building
	text += "\nOutputs\n"
	for key in building_data.output_generation.keys():
		var resource_type: String = Enums.resource_type_to_string(key)
		var output_amount: String = str(building_data.output_generation.get(key))
		
		if building_data is AreaGatheringBuildingData and !Enums.is_emission(key):
			var gather_radius: int = building_data.gather_radius
			var size_x: int = building_data.building_size.x
			var size_y: int = building_data.building_size.y
			var area: String = str(size_x + 2 * gather_radius) +"x" + str(size_y + 2 * gather_radius)
			text += resource_type + ": " + area + " area. Base gather rate of " + output_amount  + " at the center, decreasing with further tiles." + '\n'
		elif Enums.is_a_polluting_building(building_data.building_type) and Enums.is_emission(key):
			text += resource_type + ": In an area." + '\n'
		elif Enums.is_gathering_building(building_data.building_type) and !Enums.is_emission(key):
			text += resource_type + ': ' + output_amount + " per tile" + '\n'
		else:
			text += resource_type + ': ' + output_amount + '\n'

	## Adds all the different inputs of the building
	text += "\nInputs\n"
	for key in building_data.input_use_rates.keys():
		text += Enums.resource_type_to_string(key) + ': ' + str(building_data.input_use_rates.get(key)) + '\n'
	
	## Adds valid placement tiles to the text
	text += "\nPlacement\n"
	for tile in building_data.valid_tile_types_to_place_on:
		text += Enums.tile_type_to_string(tile) + '\n'
	
	## Adds storage capacity to the text
	text += "\nStorage\n"
	for key in building_data.max_storage.keys():
		text += Enums.resource_type_to_string(key) + ': ' + str(building_data.max_storage.get(key)) + '\n'
	
	
	return text

## Hide the info panel
func set_inactive() -> void:
	self.hide()

## Show the info panel and update its information
func set_active(building: Building) -> void:
	self.show()
	populate_info_label(building)
