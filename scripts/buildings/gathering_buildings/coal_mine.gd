class_name CoalMine
extends GatheringBuilding
## A class that is for the aspects of a coal mine.
##
## A class that is for the aspects of a coal mine. This class extends from
## the GatheringBuilding class.
##

@export var smokes: Array[GPUParticles2D]

func _ready():
	super()

## Activated at the end of each cycle.
func _on_timer_timeout() -> void:
	_output_resources()
	
	if check_if_can_produce() == false:
		for smoke in smokes:
			smoke.emitting = false
	else:
		for smoke in smokes:
			smoke.emitting = true
