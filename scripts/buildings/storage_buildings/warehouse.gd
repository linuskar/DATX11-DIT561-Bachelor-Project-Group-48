class_name Warehouse
extends StorageBuilding
## A class that is for the aspects of a warehouse.
##w
## A class that is for the aspects of a warehouse. This class extends from
## the StorageBuilding class.
##
func _ready() -> void:
	$place_animation.play("place")


func _on_place_animation_animation_finished(anim_name: StringName) -> void:
	$place_particle.emitting = true
