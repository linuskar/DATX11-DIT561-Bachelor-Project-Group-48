class_name Building
extends StaticBody2D
## A class that is for basic aspects of a building
##
## A class that is for basic aspects of a building, containing it's building type
## and its sprite for visual representation. 
##

## The metadat for the building
# @export var building_type: Enums.BuildingType
@export var building_data: BuildingData  # Reference to metadata

## The sprite of the building
@onready var building_sprite: Sprite2D = $Sprite2D
