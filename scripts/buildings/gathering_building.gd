class_name GatheringBuilding
extends ProductionBuilding
## A class that is for aspects of a building that can gather resources
##
## A class that is for aspects of a building that can gather resources
## This class extends the ProductionBuilding class
##

## The type of resource the building can gather
var can_gather_resource_type: Enums.ResourceType

func _ready() -> void:
	can_gather_resource_type = building_data.can_gather_resource_type
