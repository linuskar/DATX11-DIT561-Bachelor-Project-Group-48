extends Control

@onready var image = $ScrollContainer/Information/FactoryImage
@onready var building_name = $ScrollContainer/Information/BuildingName
@onready var info = $ScrollContainer/Information/BuildingInfo

func _ready() -> void:
	BuildingSignals.building_clicked.connect(set_active)
	set_inactive()
	

func populate_info_label(building: Building) -> void:
	image.set_texture(building.building_sprite.texture)
	building_name.set_text(Enums.building_type_to_string(building.building_data.building_type))
	info.text = get_text(building.building_data)


func get_text(building_data: ProductionBuildingData) -> String:
	var text: String = ""
	for key in building_data.output_generation:
		text += Enums.resource_type_to_string(key) + '\n'
	return text

func set_inactive() -> void:
	self.position = Vector2(0.0, 0.0) - self.size

func set_active(building: Building) -> void:
	self.position = Vector2(0.0, 0.0)
	populate_info_label(building)
