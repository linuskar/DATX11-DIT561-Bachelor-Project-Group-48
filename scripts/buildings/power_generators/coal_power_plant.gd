class_name CoalPowerPlant
extends ProductionBuilding
## A class that is for the aspects of a coal power plant.
##
## A class that is for the aspects of a coal power plant. This class extends from
## the ProductionBuilding class.
##

func _ready():
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
