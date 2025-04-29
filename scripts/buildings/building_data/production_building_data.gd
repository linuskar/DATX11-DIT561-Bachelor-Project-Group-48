class_name ProductionBuildingData
extends StorageBuildingData
## A class that represents the metadata for a production building
##
## A class that represents the metadata for a production building. 
## Allowing for easier access of metadata about a building without having 
## to instantiate the node. This class extends the StorageBuildingData class.
##

## The rates/quantity of input resources the production building uses each cycle.
@export var input_use_rates: Dictionary[Enums.ResourceType, int]
## The rates/quantity of resources the production building outputs each cycle.
@export var output_generation: Dictionary[Enums.ResourceType, int] 

## The radius in which the emissions gets emitted to, in a square area
@export var emissions_radius: Dictionary[Enums.ResourceType, int]

## A dictionary containing the recipes to produce for a building.
## The value is an int, acting as an ID for the recipe.
## NOTE: Due to how you can't type nested arrays, connect the ID correctly for each recipe.
@export var input_recipes: Dictionary[Enums.ResourceType, int]

func accept(handler: BuildingInfo) -> String:
	return handler.handle_prod_building(self)
