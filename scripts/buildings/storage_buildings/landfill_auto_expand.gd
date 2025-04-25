class_name LandfillAutoExpand
extends Sprite2D

## The highlight of a building for when it is selected
@onready var highlight: BuildingHighlight
@onready var place_animation: AnimationPlayer = $place_animation
@onready var place_particle: GPUParticles2D = $place_particle
@onready var deplace_particle: GPUParticles2D = $deplace_particle
@onready var clickable: Clickable = $Clickable

var highlight_scene: PackedScene = preload("res://scenes/buildings/highlight.tscn")

## TODO: Add collision shape, but right now it is not relevant for any logic
## var new_collision_shape: CollisionShape2D = null
func _ready() -> void:
	highlight = highlight_scene.instantiate()
	highlight.building_size = get_parent().building_data.building_size 

	add_child(highlight)
	highlight.de_selected()
	
	clickable.building = get_parent()
	place_animation.play("place")
	deplace_particle.finished.connect(self.queue_free)

func remove() -> void:
	deplace_particle.emitting = true

func _on_place_animation_animation_finished(anim_name: StringName) -> void:
	place_particle.emitting = true
