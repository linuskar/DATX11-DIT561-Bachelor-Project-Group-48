class_name GatheringBuilding
extends ProductionBuilding
## A class that is for aspects of a building that can gather resources
##
## A class that is for aspects of a building that can gather resources containing
## the type of resource it can gather. This class extends the building class
##

## The resource the building can gather
@export var can_gather_resource_type: Enums.ResourceType
