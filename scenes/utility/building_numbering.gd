class_name BuildingNumbering extends PanelContainer

## The number of buildings selected of this type
var number_of_buildings: int = 0
## The type of building
var building_type: Enums.BuildingType
## Texture to be loaded into the texture rect
var texture: Texture
## The texture rect of the panel
@onready var texture_rect: TextureRect = $MarginContainer/HBoxContainer/TextureRect
## The label displaying the number of buildings
@onready var label: Label = $MarginContainer/HBoxContainer/Label

func ready_instance(building_type: Enums.BuildingType, building: Building) -> void:
	self.building_type = building_type
	self.texture = building.building_sprite.texture

func update_text() -> void:
	label.text = "x " + str(number_of_buildings)

func _on_ready() -> void:
	if self.building_type:
		self.texture_rect.texture = self.texture
