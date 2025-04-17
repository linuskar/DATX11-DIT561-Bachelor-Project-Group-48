class_name AreaGatheringBuildingData
extends GatheringBuildingData
## A class that represents the metadata for an area gathering building
##
## A class that represents the metadata for an area gathering building, where it 
## gathers resoruce in area around it.
## Allowing for easier access of metadata about a building without having 
## to instantiate the node. This class extends the GatheringBuildingData class.
##

## The radius in tiles for which the gathering building can gather in (a square area).
@export var gather_radius: int

func accept(handler: BuildingInfo) -> String:
	return handler.handle_areagath_building(self)
