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
@export var research_required: String = ""

## The sprite of the building
@onready var building_sprite: Sprite2D = $Sprite2D

## The building type
var building_type: Enums.BuildingType
	
func _ready() -> void:
	building_type = building_data.building_type
	if research_required != "":
		if Research.has_completed(research_required):
			apply_research_upgrade()
		else:
			Research.research_completed.connect(_on_research_completed)

func _on_research_completed(id: String) -> void:
	if id == research_required:
		apply_research_upgrade()

# this is a placeholder, override in child for specific upgrades
func apply_research_upgrade() -> void:
	print("Upgrade applied for: ", self.name)
