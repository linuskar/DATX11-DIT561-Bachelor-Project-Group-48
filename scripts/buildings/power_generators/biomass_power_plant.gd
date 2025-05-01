class_name BiomassPowerPlant
extends ProductionBuilding
## A class that is for the aspects of a biomass power plant.
##
## A class that is for the aspects of a biomass power plant. This class extends from
## the ProductionBuilding class.
##

func _ready():
	$place_animation.play("place")
	super()

func _on_place_animation_animation_finished(anim_name: StringName) -> void:
	$place_particle.emitting = true
