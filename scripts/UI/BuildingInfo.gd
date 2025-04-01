class_name BuildingInfo extends Control

@onready var image = $ScrollContainer/VBoxContainer/MarginContainer3/FactoryImage
@onready var building_name = $ScrollContainer/VBoxContainer/BuildingName
@onready var info = $ScrollContainer/VBoxContainer/MarginContainer4/PanelContainer/MarginContainer/BuildingInfo

var show_emissions = false

func _ready() -> void:
	BuildingSignals.building_clicked.connect(set_active)
	set_inactive()
	

func populate_info_label(building: Building) -> void:
	image.set_texture(building.building_sprite.texture)
	building_name.set_text(Enums.building_type_to_string(building.building_data.building_type))
	info.text = get_text(building.building_data)

## Formating building data into a string that is then displayed in the
## building info panel.
func get_text(building_data: BuildingData) -> String:
	return building_data.accept(self)

func set_inactive() -> void:
	self.hide()

func handle_building(building: BuildingData) -> String:
	var text: String = ""
	
	## Adds valid placement tiles to the text
	text += "\nPlacement\n"
	for tile in building.valid_tile_types_to_place_on:
		text += Enums.tile_type_to_string(tile) + '\n'
	
	return text
	
func handle_prod_building(building: ProductionBuildingData) -> String:
	var text: String = ""
	
	## Adds all the different outputs of the building
	text += "\nOutputs\n"
	for key in building.output_generation.keys():
		text += Enums.resource_type_to_string(key) + ': ' + str(building.output_generation.get(key)) + '\n'

	## Adds all the different inputs of the building
	text += "\nInputs\n"
	for key in building.input_use_rates.keys():
		text += Enums.resource_type_to_string(key) + ': ' + str(building.input_use_rates.get(key)) + '\n'
	
	## Adds valid placement tiles to the text
	text += "\nPlacement\n"
	for tile in building.valid_tile_types_to_place_on:
		text += Enums.tile_type_to_string(tile) + '\n'
	
	## Adds storage capacity to the text
	text += "\nStorage\n"
	for key in building.max_storage.keys():
		text += Enums.resource_type_to_string(key) + ': ' + str(building.max_storage.get(key)) + '\n'
	return text

func handle_gath_building(building: GatheringBuildingData) -> String:
	return "Hej"

func set_active(building: Building) -> void:
	self.show()
	populate_info_label(building)
