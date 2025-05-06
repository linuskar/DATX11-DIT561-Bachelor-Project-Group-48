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
@export var available_research: Array[ResearchData]

## The sprite of the building
@onready var building_sprite: Sprite2D = $Sprite2D

@export var scene_place_sound: PackedScene
var place_sound: AudioStreamPlayer2D

@export var scene_place_animation: PackedScene
@export var scene_place_particle: PackedScene
var place_particle: GPUParticles2D
var place_animation: AnimationPlayer
## The highlight of a building for when it is selected
@onready var highlight: BuildingHighlight

var highlight_scene: PackedScene = preload("res://scenes/buildings/highlight.tscn")

## The building type
var building_type: Enums.BuildingType

## Boolean for when the building is currently selected by the player
var currently_selected: bool

func _ready() -> void:
	
	place_particle = scene_place_particle.instantiate()
	place_animation = scene_place_animation.instantiate()
	place_sound = scene_place_sound.instantiate()
	add_child(place_animation)
	add_child(place_particle)
	add_child(place_sound)
	place_animation.play("place")
	place_animation.connect("animation_finished", _on_place_animation_animation_finished)
	
func _on_place_animation_animation_finished(anim_name: StringName) -> void:
	place_particle.emitting = true
	place_sound.pitch_scale = randf_range(0.8, 1.2)
	place_sound.play()
	highlight = highlight_scene.instantiate()
	highlight.building_size = building_data.building_size
	add_child(highlight)
	highlight.unselected()
	
	BuildingSignals.building_info_closed.connect(building_deselected)
	
	building_type = building_data.building_type
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

func _on_research_completed(id: Enums.ResearchID) -> void:
	for reserach in available_research:
		if id == reserach.research_id:
			apply_research_upgrade(id)

# this is a placeholder, override in child for specific upgrades
func apply_research_upgrade(id: Enums.ResearchID) -> void:
	pass

func get_building() -> Building:
	return self
