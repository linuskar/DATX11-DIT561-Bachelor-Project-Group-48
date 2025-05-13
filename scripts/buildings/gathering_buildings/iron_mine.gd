class_name IronMine
extends GatheringBuilding
## A class that is for the aspects of an iron mine.
##
## A class that is for the aspects of an iron mine. This class extends from
## the GatheringBuilding class.
##

func _ready():
	$place_animation.play("place")
	super()

func _on_place_animation_animation_finished(anim_name: StringName) -> void:
	$place_particle.emitting = true
