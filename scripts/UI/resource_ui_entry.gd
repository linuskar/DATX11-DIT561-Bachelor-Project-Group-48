class_name ResourceUIEntry extends VBoxContainer

var resource_type: Enums.ResourceType
var texture_to_load: Texture
@onready var texture_rect: TextureRect = $TextureRect
@onready var label: Label = $Label

func _ready() -> void:
	texture_rect.texture = texture_to_load
