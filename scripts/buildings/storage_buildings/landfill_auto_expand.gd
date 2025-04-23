class_name LandfillAutoExpand
extends Sprite2D

@onready var highlight: BuildingHighlight = $Highlight
@onready var place_animation: AnimationPlayer = $place_animation
@onready var place_particle: GPUParticles2D = $place_particle
@onready var deplace_particle: GPUParticles2D = $deplace_particle
@onready var clickable: Clickable = $Clickable

## TODO: Add collision shape, but right now it is not relevant for any logic
## var new_collision_shape: CollisionShape2D = null
func _ready() -> void:
	clickable.building = get_parent()
	place_animation.play("place")
	deplace_particle.finished.connect(self.queue_free)

func remove() -> void:
	deplace_particle.emitting = true

func _on_place_animation_animation_finished(anim_name: StringName) -> void:
	place_particle.emitting = true
