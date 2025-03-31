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
@export var emissions_radius: int
