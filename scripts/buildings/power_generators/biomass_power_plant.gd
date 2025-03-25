class_name BiomassPowerPlant
extends ProductionBuilding
## A class that is for the aspects of a biomass power plant.
##
## A class that is for the aspects of a biomass power plant. This class extends from
## the ProductionBuilding class.
##

@export var smokes: Array[GPUParticles2D]

func _ready():
	super()
	## Test if power generates
	input_storage.set(Enums.ResourceType.BIOMASS, 100)

## Activated at the end of each cycle.
func _on_timer_timeout() -> void:
	_output_resources()
	
	if check_if_can_produce() == false:
		for smoke in smokes:
			smoke.emitting = false
	else:
		for smoke in smokes:
			smoke.emitting = true
