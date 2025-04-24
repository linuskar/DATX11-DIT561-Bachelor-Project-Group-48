class_name GatheringBuilding
extends ProductionBuilding
## A class that is for aspects of a building that can gather resources.
##
## A class that is for aspects of a building that can gather resources.
## This class extends the ProductionBuilding class.
##
##

## The type of resource the building can gather.
var can_gather_resource_type: Enums.ResourceType

## A boolean to check if the gathering building is near a resource.
var near_resource: bool
## The resource tiles the gathering building is on 
var resource_tiles_to_gather: Dictionary[Vector2, GatherableResource]

func _ready() -> void:
	super()
	can_gather_resource_type = building_data.can_gather_resource_type
	near_resource = false
	
## Function to check if the gathering building can produce.
func check_if_can_produce() -> bool:
	var missing_input: bool = check_for_missing_input()
	var can_be_output_overflow: bool = check_for_output_overflow()
	
	if missing_input:
		return false
		
	if can_be_output_overflow:
		return false
	
	if !near_resource:
		return false
	
	return true

## Function to check if the production building is going to overflow with 
## resources in output.
func check_for_output_overflow() -> bool:
	for produced_good in produced_goods:
		var produced_good_generated: int = output_generation.get(produced_good)*resource_tiles_to_gather.size()
		var produced_good_stored: int = output_storage.get(produced_good)
		var produced_good_max_storage: int = max_storage.get(produced_good)
		var produced_good_string = Enums.resource_type_to_string(produced_good)
		
		## When at possible overflow of resources for output
		if produced_good_stored + produced_good_generated > produced_good_max_storage:
			return true
	return false

## Function to produce the goods the gathering building can output.
func _produce_goods() -> Dictionary[Enums.ResourceType, int]:
	var resources_produced: Dictionary[Enums.ResourceType, int]
	for produced_good in produced_goods:
		var gather_rate_per_tile: int = output_generation.get(produced_good)
		var produced_good_generated: int = 0
		
		## Gathering on the tiles the building is on
		for resource_pos in resource_tiles_to_gather.keys():
			if is_instance_valid(resource_tiles_to_gather.get(resource_pos)):
				var gatherable_resource = resource_tiles_to_gather.get(resource_pos)
				produced_good_generated += gatherable_resource.gather_resource(gather_rate_per_tile)

				if gatherable_resource.quantity <= 0:
					resource_tiles_to_gather.erase(resource_pos)
			else:
				resource_tiles_to_gather.erase(resource_pos)
		resources_produced.set(produced_good, produced_good_generated)
		
		if resource_tiles_to_gather.size() == 0:
			near_resource = false
	return resources_produced
