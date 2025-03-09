class_name Building
extends StaticBody2D
## A class that is for basic aspects of a building
##
## A class that is for basic aspects of a building, containing it's building type
## and its sprite for visual representation. 
##

## The building type
@export var building_type: Enums.BuildingType

## If the building can gather resources
@export var can_gather: bool

## The sprite of the building
@onready var building_sprite: Sprite2D = $Sprite2D

#func start_gathering
