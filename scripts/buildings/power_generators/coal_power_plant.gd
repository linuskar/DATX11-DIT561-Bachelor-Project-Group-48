class_name CoalPowerPlant
extends ProductionBuilding
## A class that is for the aspects of a coal power plant.
##
## A class that is for the aspects of a coal power plant. This class extends from
## the ProductionBuilding class.
##

## The nodes emitting smoke.
@export var smokes: Array[GPUParticles2D]

func _ready():
	$place_animation.play("place")
	super()
	emit_smoke()
	
func _output_resources() -> void:
	emit_smoke() 
	super()

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
