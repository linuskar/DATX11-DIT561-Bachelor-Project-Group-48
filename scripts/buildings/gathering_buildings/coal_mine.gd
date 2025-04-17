class_name CoalMine
extends GatheringBuilding
## A class that is for the aspects of a coal mine.
##
## A class that is for the aspects of a coal mine. This class extends from
## the GatheringBuilding class.
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
			
## Function for emitting smoke when possible.
func emit_smoke() -> void:
	if check_if_can_produce() == false or PlayerCurrency.player_held_currency < self.building_data.building_upkeep:
		for smoke in smokes:
			smoke.emitting = false
	else:
		for smoke in smokes:
			smoke.emitting = true
			$mining_particle.emitting = true


func _on_place_animation_animation_finished(anim_name: StringName) -> void:
	$place_particle.emitting = true
