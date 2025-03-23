class_name MapBounds
extends Area2D
## A class that represents the bounds of the map
##
## A class that represents the bounds of the map, where the playable
## area of the game is. This class extends Area2D.
##

## Signal for when the mouse is in or not in the map
signal mouse_in_map(is_in_map)

func _ready():
	connect("mouse_entered", _on_mouse_entered)
	connect("mouse_exited", _on_mouse_exited)
	
## Function for when the mouse enters the map bounds
func _on_mouse_entered():
	mouse_in_map.emit(true)
	
## Function for when the mouse exits the map bounds
func _on_mouse_exited():
	mouse_in_map.emit(false)
