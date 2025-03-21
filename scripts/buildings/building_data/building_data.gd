class_name BuildingData
extends Resource
## A class that represents the metadata for a basic building
##
## A class that represents the metadata for a building. Allowing for easier 
## access of metadata about a building without having to instantiate the node.
## This class extends the Resource class.

## What type of building it is.
@export var building_type: Enums.BuildingType

@export var valid_placeable_tiles: Array[Enums.TileType]
