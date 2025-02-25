class_name Building
extends Area2D

@export var building_type: Enums.BuildingType:
	get:
		return building_type

@onready var building_sprite: Sprite2D = $Sprite2D
