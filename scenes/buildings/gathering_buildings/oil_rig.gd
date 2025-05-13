class_name OilRig
extends GatheringBuilding
## A class that is for the aspects of a oil rig.
##
## A class that is for the aspects of a oil rig. This class extends from
## the GatheringBuilding class.
##

func _ready():
	$place_animation.play("place")
	super()

func _on_place_animation_animation_finished(anim_name: String) -> void:
	$place_particle.emitting = true

## Function for emitting smoke when possible.
func emit_smoke() -> void:
	if check_if_can_produce() == false or PlayerCurrency.player_held_currency < self.building_data.building_upkeep:
		for smoke in smokes:
			smoke.emitting = false
	else:
		for smoke in smokes:
			smoke.emitting = true
			$mining_particle.emitting = true
