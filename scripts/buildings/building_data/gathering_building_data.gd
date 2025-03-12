class_name GatheringBuildingData
extends ProductionBuildingData
## A class that represents the metadata for a gathering building
##
## A class that represents the metadata for a gathering building. 
## Allowing for easier access of metadata about a building without having 
## to instantiate the node. This class extends the ProductionBuildingData class.
##

## The resources the building can gather.
@export var can_gather_resource_type: Enums.ResourceType
