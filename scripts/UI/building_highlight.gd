class_name BuildingHighlight
extends Control

@onready var color_rect: ColorRect = $ColorRect

func _ready() -> void:
	color_rect.hide()
	
func selected() -> void:
	color_rect.show()

func de_selected() -> void:
	color_rect.hide()
