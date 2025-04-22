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

@export var scene_place_sound: PackedScene
var place_sound: AudioStreamPlayer2D

@export var scene_place_animation: PackedScene
@export var scene_place_particle: PackedScene
var place_particle: GPUParticles2D
var place_animation: AnimationPlayer
## The building type
var building_type: Enums.BuildingType
	
func _ready() -> void:
	
	place_particle = scene_place_particle.instantiate()
	place_animation = scene_place_animation.instantiate()
	place_sound = scene_place_sound.instantiate()
	add_child(place_animation)
	add_child(place_particle)
	add_child(place_sound)
	place_animation.play("place")
	place_animation.connect("animation_finished", _on_place_animation_animation_finished)
	building_type = building_data.building_type
	
func _on_place_animation_animation_finished(anim_name: StringName) -> void:
	place_particle.emitting = true
	place_sound.pitch_scale = randf_range(0.8, 1.2)
	place_sound.play()
