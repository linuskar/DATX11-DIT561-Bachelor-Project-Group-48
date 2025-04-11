class_name BuildingData
extends Resource
## A class that represents the metadata for a basic building
##
## A class that represents the metadata for a building. Allowing for easier 
## access of metadata about a building without having to instantiate the node.
## This class extends the Resource class.

## What type of building it is.
@export var building_type: Enums.BuildingType
## What types of tiles the building can be placed on 
@export var valid_tile_types_to_place_on: Array[Enums.TileType]
## What the size of the building is in terms of amount of tiles it takes
@export var building_size: Vector2
## The amount of currency it costs to build the building
@export var building_cost: int
## The upkeep cost of the building
@export var building_upkeep: int

## Takes in a handler entity and calls the handlers
## function which is connected to this specific instance.
## The handler will have one function for each case it needs
## to handle. Examples: handle_building, handle_prod_building.
func accept(handler: BuildingInfo) -> String:
	return handler.handle_building(self)
