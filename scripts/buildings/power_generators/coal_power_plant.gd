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
	super()
	## Test if power generates
	input_storage.set(Enums.ResourceType.COAL, 100)
	emit_smoke()

## Activated at the end of each cycle.
func _on_timer_timeout() -> void:
	_output_resources()
	emit_smoke()
			
## Function for emitting smoke when possible
func emit_smoke():
	if check_if_can_produce() == false:
		for smoke in smokes:
			smoke.emitting = false
	else:
		for smoke in smokes:
			smoke.emitting = true
