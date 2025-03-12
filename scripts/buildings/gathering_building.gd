class_name GatheringBuilding
extends ProductionBuilding
## A class that is for aspects of a building that can gather resources
##
## A class that is for aspects of a building that can gather resources
## This class extends the ProductionBuilding class
##

## The type of resource the building can gather
var can_gather_resource_type: Enums.ResourceType

##
var near_resource: bool

func _ready() -> void:
	super()
	can_gather_resource_type = building_data.can_gather_resource_type

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
