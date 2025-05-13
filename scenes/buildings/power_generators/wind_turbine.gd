class_name WindTurbine
extends ProductionBuilding
## A class that is for the aspects of a wind turbine.
##
## A class that is for the aspects of a wind turbine. This class extends from
## the ProductionBuilding class.
##

func _ready():
	$place_animation.play("place")
	super()


func _on_place_animation_animation_finished(anim_name: String) -> void:
	$place_particle.emitting = true
