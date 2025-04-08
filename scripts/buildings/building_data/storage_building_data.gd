class_name StorageBuildingData
extends BuildingData
## A class that represents the metadata for a storage building.
##
## A class that represents the metadata for a storage building. 
## Allowing for easier access of metadata about a building without having 
## to instantiate the node. This class extends the BuildingData class.
##
##

## The max storage of the resources the production building interacts with.
@export var max_storage: Dictionary[Enums.ResourceType, int]
## The input types of the resources the storage building takes in.
@export var input_types: Array[Enums.ResourceType] 
## The types of resources the storage building outputs.
@export var output_types: Array[Enums.ResourceType] 
