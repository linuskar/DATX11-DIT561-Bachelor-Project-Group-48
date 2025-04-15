class_name BiomassPowerPlant
extends ProductionBuilding
## A class that is for the aspects of a biomass power plant.
##
## A class that is for the aspects of a biomass power plant. This class extends from
## the ProductionBuilding class.
##

## The nodes emitting smoke.
@export var smokes: Array[GPUParticles2D]

func _ready():
	$place_animation.play("place")
	super()
	emit_smoke()
	
## Activated at the end of each cycle.
func _on_timer_timeout() -> void:
	_output_resources()
	emit_smoke()
			
## Function for emitting smoke when possible
func emit_smoke() -> void:
	if check_if_can_produce() == false or PlayerCurrency.player_held_currency < self.building_data.building_upkeep:
		for smoke in smokes:
			smoke.emitting = false
	else:
		for smoke in smokes:
			smoke.emitting = true


func _on_place_animation_animation_finished(anim_name: StringName) -> void:
	$place_particle.emitting = true
