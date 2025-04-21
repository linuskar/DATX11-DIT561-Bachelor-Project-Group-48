class_name Smog
extends ColorRect

@onready var pollution_manager: PollutionManager = $"../PollutionManager"

var smog_limit: float = pow(10,6)

func _process(delta: float) -> void:
	var emission_amount: float = 0
	
	for emission in Enums.emissions_contributing_to_smog:
		if pollution_manager.emissions_not_absorbed.has(emission):
			emission_amount += pollution_manager.emissions_not_absorbed.get(emission)
			
	emission_amount = min(emission_amount, smog_limit)
	emission_amount = inverse_lerp(0.0, smog_limit, emission_amount)
	material.set_shader_parameter("density", emission_amount)
