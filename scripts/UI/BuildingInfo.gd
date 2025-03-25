extends Control

@onready var image = $ScrollContainer/Information/FactoryImage
@onready var building_name = $ScrollContainer/Information/BuildingName
@onready var info = $ScrollContainer/Information/BuildingInfo

func _ready() -> void:
	BuildingSignals.building_clicked.connect(populate_info_label)

func populate_info_label(building: Building) -> void:
	print("Got here!")
	image.set_texture(building.building_sprite.texture)
	building_name.set_text(Enums.building_type_to_string(building.building_data.building_type))
	info.set_text(get_text(building.building_data))


func get_text(building_data: ProductionBuildingData) -> String:
	var text: String = ""
	for key in building_data.output_generation:
		text += str(key) + '\n'
	return text
