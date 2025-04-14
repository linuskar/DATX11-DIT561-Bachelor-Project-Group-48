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
	super()
	emit_smoke()

## Activated at the end of each cycle.
func _on_timer_timeout() -> void:
	_output_resources()
	emit_smoke()
			
## Function for emitting smoke when possible.
func emit_smoke() -> void:
	if check_if_can_produce() == false or PlayerCurrency.player_held_currency < self.building_data.building_upkeep:
		for smoke in smokes:
			smoke.emitting = false
	else:
		for smoke in smokes:
			smoke.emitting = true
