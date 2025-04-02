class_name BuildingBlueprint
extends Area2D
## A class that is for basic aspects of a building blueprint
##
## A class that is for basic aspects of a building blueprint, containing it's basic 
## metadata and its sprite for visual representation. 
##
##

## The metadata for the building blueprint
@export var building_data: BuildingData  

## The sprite of the building blueprint
@onready var building_sprite: Sprite2D = $Sprite2D

## The building type of building blueprint
var building_type: Enums.BuildingType
	
func _ready() -> void:
	building_type = building_data.building_type
