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

func _ready() -> void:
	super()
	can_gather_resource_type = building_data.can_gather_resource_type
	
## Function to check if the gathering building can produce.
func check_if_can_produce() -> bool:
	var missing_input: bool = check_for_missing_input()
	var can_be_output_overflow: bool = check_for_output_overflow()
	
	if missing_input:
		return false
		
	if can_be_output_overflow:
		return false
	
	if near_resource == false:
		return false
	
	return true

## Activated at the end of each cycle.
func _on_timer_timeout() -> void:
	_output_resources()
	
## Function to begin outputting resources from the production building.
func _output_resources() -> void:
	if !check_if_can_produce():
		print("Can't produce")
		production_cycle.stop()
	else:
		var building_type_string: String = Enums.building_type_to_string(building_data.building_type)
		print(building_type_string + " is producing")
		_produce_goods()
		_use_input_recipe()
		_generate_byproducts()
