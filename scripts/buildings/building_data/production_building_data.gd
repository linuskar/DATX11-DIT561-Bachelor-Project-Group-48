class_name ProductionBuildingData
extends BuildingData
## A class that represents the metadata for a production building
##
## A class that represents the metadata for a production building. 
## Allowing for easier access of metadata about a building without having 
## to instantiate the node. This class extends the BuildingData class.
##

## The max storage of the resources the production building interacts with.
@export var max_storage: Dictionary[Enums.ResourceType, int]
## The input types of the resources the production building uses.
@export var input_types: Array[Enums.ResourceType] 
## The rates/quantity of input resources the production building uses each cycle.
@export var input_use_rates: Dictionary[Enums.ResourceType, int]
## The types of resources the production building outputs.
@export var output_types: Array[Enums.ResourceType] 
## The rates/quantity of resources the production building outputs each cycle.
@export var output_generation: Dictionary[Enums.ResourceType, int] 

func accept(handler: BuildingInfo) -> String:
	return handler.handle_prod_building(self)
