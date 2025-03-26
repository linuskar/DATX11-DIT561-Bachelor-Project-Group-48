class_name GatherableTree
extends GatherableResource

@export var emission_storage: Dictionary[Enums.ResourceType, int]
@export var emission_max_capacity: Dictionary[Enums.ResourceType, int]

func _ready() -> void:
	pass

func check_if_at_emission_limit() -> bool:
	for emission_type in emission_storage.keys():
		
		var emission_stored: int = emission_storage.get(emission_type)
		var emission_limit = emission_max_capacity.get(emission_type)
		
		if emission_stored >= emission_limit:
			queue_free()
			return true
			#print("tree destroyed")
	#print("tree not destroyed")
	return false
	
func absorb_emission(emission_type: Enums.ResourceType, amount: int):
	#print("absorbed emission")
	var current_emission_stored: int = emission_storage.get(emission_type)
	emission_storage.set(emission_type, amount + current_emission_stored)
