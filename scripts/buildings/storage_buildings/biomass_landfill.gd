class_name BiomassLandfill
extends StorageBuilding
## A class that is for the aspects of a biomass landfill.
##
## A class that is for the aspects of a biomass landfill. This class extends from
## the StorageBuilding class.
##
func _ready() -> void:
	super()
	$place_animation.play("place")


func _on_place_animation_animation_finished(anim_name: StringName) -> void:
	$place_particle.emitting = true
