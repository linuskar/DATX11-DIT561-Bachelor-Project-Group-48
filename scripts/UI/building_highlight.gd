class_name BuildingHighlight
extends Control
## A class that represents the highlihting of a building.
##
## A class that represents the highlihting of a building, that is when it is
## selected and de-selected.
## 
##

## The current higlighting is visualized by a ColorRect
@onready var color_rect: ColorRect = $ColorRect

func _ready() -> void:
	de_selected()
	init_size()
	
func init_size() -> void:
	pass
	
func selected() -> void:
	show()
	color_rect.show()

func de_selected() -> void:
	hide()
	color_rect.hide()
