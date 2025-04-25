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
var building_size: Vector2

func _ready() -> void:
	de_selected()
	init_size()
	
func init_size() -> void:
	var grid_size: int = 32
	var x: float = grid_size * building_size.x
	var y: float = grid_size * building_size.y
	
	var highlight_size: Vector2 = Vector2(x, y)
	size = highlight_size
	color_rect.size = highlight_size
	
	position = Vector2(-x / 2, -y / 2)
	
func selected() -> void:
	show()
	color_rect.show()

func de_selected() -> void:
	hide()
	color_rect.hide()
