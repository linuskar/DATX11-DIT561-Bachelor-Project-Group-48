class_name MapAreas
extends Node
## A class that contains the bounds/areas of the map
##
## A class that contains the bounds/areas of the map, where the playable
## area of the game is and the outer map areas/bounds. 
## This class extends nodes.
##
##

## Signal for when the mouse is in or not in the map
signal mouse_in_map(is_in_map)
## Signal for when the blueprint is in or not in the map
signal blueprint_in_map(blueprint_is_in_map)

@onready var playable_area: Area2D = $PlayableArea
@onready var left_bound: Area2D = $LeftBound
@onready var right_bound: Area2D = $RightBound
@onready var lower_bound: Area2D = $LowerBound
@onready var upper_bound: Area2D = $UpperBound

var in_left_bound: bool
var in_right_bound: bool
var in_lower_bound: bool
var in_upper_bound: bool

func _ready():
	playable_area.connect("mouse_entered", _on_mouse_entered)
	playable_area.connect("mouse_exited", _on_mouse_exited)
	
	playable_area.connect("area_entered", _on_playable_area_entered)
	playable_area.connect("area_exited", _on_playable_area_exited)

func _on_playable_area_entered() -> void:
	blueprint_in_map.emit(true)

func _on_playable_area_exited() -> void:
	blueprint_in_map.emit(false)

## Function for when the mouse enters the map bounds
func _on_mouse_entered() -> void:
	print("Entered")
	mouse_in_map.emit(true)
	ZoomHandler.allow_zoom.emit(true)
	
## Function for when the mouse exits the map bounds
func _on_mouse_exited() -> void:
	print("Exited")
	mouse_in_map.emit(false)
	ZoomHandler.allow_zoom.emit(false)
