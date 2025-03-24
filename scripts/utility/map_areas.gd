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
	
	left_bound.connect("area_entered", _on_blueprint_entered_left_bound)
	left_bound.connect("area_exited", _on_blueprint_exited_left_bound)
	
	right_bound.connect("area_entered", _on_blueprint_entered_right_bound)
	right_bound.connect("area_exited", _on_blueprint_exited_right_bound)
	
	lower_bound.connect("area_entered", _on_blueprint_entered_lower_bound)
	lower_bound.connect("area_exited", _on_blueprint_exited_lower_bound)
	
	upper_bound.connect("area_entered", _on_blueprint_entered_upper_bound)
	upper_bound.connect("area_exited", _on_blueprint_exited_upper_bound)
	
## Function for when the mouse enters the map bounds
func _on_mouse_entered() -> void:
	mouse_in_map.emit(true)
	
## Function for when the mouse exits the map bounds
func _on_mouse_exited() -> void:
	mouse_in_map.emit(false)

func is_blueprint_in_map() -> bool:
	return not in_left_bound and not in_right_bound and not in_lower_bound and not in_upper_bound

func _on_blueprint_entered_left_bound(area: Area2D) -> void:
	in_left_bound = true
	blueprint_in_map.emit(is_blueprint_in_map())

func _on_blueprint_exited_left_bound(area: Area2D) -> void:
	in_left_bound = false
	blueprint_in_map.emit(is_blueprint_in_map())

func _on_blueprint_entered_right_bound(area: Area2D) -> void:
	in_right_bound = true
	blueprint_in_map.emit(is_blueprint_in_map())

func _on_blueprint_exited_right_bound(area: Area2D) -> void:
	in_right_bound = false
	blueprint_in_map.emit(is_blueprint_in_map())

func _on_blueprint_entered_lower_bound(area: Area2D) -> void:
	in_lower_bound = true
	blueprint_in_map.emit(is_blueprint_in_map())

func _on_blueprint_exited_lower_bound(area: Area2D) -> void:
	in_lower_bound = false
	blueprint_in_map.emit(is_blueprint_in_map())

func _on_blueprint_entered_upper_bound(area: Area2D) -> void:
	in_upper_bound = true
	blueprint_in_map.emit(is_blueprint_in_map())

func _on_blueprint_exited_upper_bound(area: Area2D) -> void:
	in_upper_bound = false
	blueprint_in_map.emit(is_blueprint_in_map())
