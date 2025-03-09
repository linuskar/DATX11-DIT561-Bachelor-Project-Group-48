class_name SelectableBuilding extends Control

## Path pointing to the icon representing the building
@export var iconPath: String

## The cost of the building
@export var cost: int

## The name of the building
@export var buildingName: String

## The list of names and amounts of inputs to the building
@export var inputs: Dictionary

## The list of resources that can be contributed to lower cost
@export var contributables: Dictionary

## The list of resources that are required to place the building
@export var required: Dictionary

func _ready() -> void:
	self.get_child(0).visible = false
	self.get_child(0).mouse_filter = MOUSE_FILTER_IGNORE

func _on_main_panel_mouse_entered() -> void:
	self.get_child(0).visible = true
	self.get_child(0).mouse_filter = MOUSE_FILTER_STOP


func _on_main_panel_mouse_exited() -> void:
	self.get_child(0).visible = false
	self.get_child(0).mouse_filter = MOUSE_FILTER_IGNORE
