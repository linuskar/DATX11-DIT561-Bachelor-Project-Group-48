class_name Building
extends StaticBody2D
## A class that is for basic aspects of a building
##
## A class that is for basic aspects of a building, containing it's basic 
## metadata and its sprite for visual representation. 
##
##

## The metadata for the building
@export var building_data: BuildingData  

## The sprite of the building
@onready var building_sprite: Sprite2D = $Sprite2D

## The building type
var building_type: Enums.BuildingType
	
func _ready() -> void:
	building_type = building_data.building_type
