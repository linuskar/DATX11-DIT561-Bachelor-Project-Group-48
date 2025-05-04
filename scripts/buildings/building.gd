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

## The highlight of a building for when it is selected
@onready var highlight: BuildingHighlight

var highlight_scene: PackedScene = preload("res://scenes/buildings/highlight.tscn")

## The building type
var building_type: Enums.BuildingType

## Boolean for when the building is currently selected by the player
var currently_selected: bool

func _ready() -> void:
	highlight = highlight_scene.instantiate()
	highlight.building_size = building_data.building_size
	add_child(highlight)
	highlight.unselected()
	
	BuildingSignals.building_info_closed.connect(building_deselected)
	
	building_type = building_data.building_type
	if research_required != "":
		if Research.has_completed(research_required):
			apply_research_upgrade()
		else:
			Research.research_completed.connect(_on_research_completed)

func _process(delta: float) -> void:
	highlight_building()

## Function to higlight the building
func highlight_building() -> void:
	if currently_selected:
		highlight.show()
		highlight.selected()
	else:
		highlight.hide()
		highlight.unselected()

## Function to set building as currently selected
func building_selected(building: Building) -> void:
	if building == self:
		currently_selected = true
	else:
		currently_selected = false
		
## Function to set building as not currently selected
func building_deselected(building: Building) -> void:
	if building == self:
		currently_selected = false

func _on_research_completed(id: String) -> void:
	if id == research_required:
		apply_research_upgrade()

# this is a placeholder, override in child for specific upgrades
func apply_research_upgrade() -> void:
	pass

func get_building() -> Building:
	return self
