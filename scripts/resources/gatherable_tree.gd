class_name GatherableTree
extends GatherableResource
## A class representing a gatherable tree.
##
## A class representing a gatherable tree that can absorb emissions. This class
## extends the GatherableResource class.
##
##

## Dictionary for the maximum capacity of emissions that can be stored.
## Set the max capacity to -1 to indicate it has unlmited max capacity
## for a resource.
@export var emission_max_capacity: Dictionary[Enums.ResourceType, float] = {}
## The current storage of emissions.
var emission_storage: Dictionary[Enums.ResourceType, float] = {}

func _ready() -> void:
	emission_storage.set(Enums.ResourceType.CO2, 0)
	emission_storage.set(Enums.ResourceType.S02, 0)

## Function to check if the stored emissions are at or above the 
## max capacity that is allowed.
func check_if_at_emission_limit() -> bool:
	for emission_type in emission_storage.keys():	
		var emission_stored: float = emission_storage.get(emission_type)
		var emission_limit = emission_max_capacity.get(emission_type)
		## Destroy the tree if the limit for sulfur dioxide is reached
		if emission_stored >= emission_limit and emission_type == Enums.ResourceType.S02:
			queue_free()
			return true
	return false

## Function to absorb emissions.
func absorb_emission(emission_type: Enums.ResourceType, amount: float):
	var amount_to_set: float = amount + emission_storage.get(emission_type)
	emission_storage.set(emission_type, amount_to_set)
