class_name SawMill
extends ProductionBuilding
## A class that is for the aspects of a saw mill.
##
## A class that is for the aspects of a saw mill. This class extends from
## the ProductionBuilding class.
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
	if check_if_can_produce() == false:
		for smoke in smokes:
			smoke.emitting = false
	else:
		for smoke in smokes:
			smoke.emitting = true
