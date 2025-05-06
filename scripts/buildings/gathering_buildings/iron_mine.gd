class_name IronMine
extends GatheringBuilding
## A class that is for the aspects of an iron mine.
##
## A class that is for the aspects of an iron mine. This class extends from
## the GatheringBuilding class.
##

## The nodes emitting smoke.
@onready var mine_sound: AudioStreamPlayer2D = $mine_sound

func _ready():
	super()
	emit_smoke()
	
func _output_resources() -> void:
	emit_smoke() 
	super()
	mine_sound.play()
			
## Function for emitting smoke when possible
func emit_smoke() -> void:
	if check_if_can_produce() == false or PlayerCurrency.player_held_currency < self.building_data.building_upkeep:
		for smoke in smokes:
			smoke.emitting = false
	else:
		for smoke in smokes:
			smoke.emitting = true
