class_name LandfillAutoExpand
extends StorageBuilding

@onready var deplace_particle: GPUParticles2D = $deplace_particle
@onready var place_animation: AnimationPlayer = $place_animation
@onready var place_particle: GPUParticles2D = $place_particle

## The texture of the landfill, to be set when ready
var texture: Texture

var main_resource: Enums.ResourceType

var auto_expand_max_capacity_amount: int

var collision_shape: CollisionShape2D = null

func _ready() -> void:
	highlight = highlight_scene.instantiate()
	highlight.building_size = get_parent().building_data.building_size
	main_resource = get_parent().main_resource
	auto_expand_max_capacity_amount = get_parent().auto_expand_max_capacity_amount
	
	add_child(highlight)
	highlight.unselected()
	
	place_animation.play("place")
	deplace_particle.finished.connect(self.queue_free)

## Function to higlight the all the connected landfills
func highlight_building() -> void:
	if currently_selected:
		get_parent().highlight_building()
	else:
		highlight.unselected()


func remove() -> void:
	deplace_particle.emitting = true

func _on_place_animation_animation_finished(anim_name: StringName) -> void:
	place_particle.emitting = true

func _on_ready() -> void:
	self.building_sprite.texture = self.texture

func get_building() -> Building:
	return get_parent()
