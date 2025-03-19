class_name ResourceManager
extends Node
## A class that manages the resources of the game
##
## A class that manages the resources of the game and any 
##
@onready var map_layer: MapLayer = $"../MapLayer"
@onready var build_manager: BuildManager = $"../BuildManager"

## The buildings that are currently gathering resources
var buildings_gathering: Array[Building]

## A dictionary containing the tiles with gatherable resoruces on the map
var resource_tiles: Dictionary[Vector2, GatherableResource] = {}

func _ready() -> void:
	build_manager.placed_building.connect(init_building_gathering)
	init_resources()

func _process(delta: float) -> void:
	## Use this function to test if resources are gathered by printing in 
	## the console, the resource gathered
	gather_resources()

## Function for initaliazing the variables for the resources
func init_resources() -> void:
	## Don't know if this is the best. But await is done to make sure the map 
	## is loaded and the resources are referenced correctly, to not get null
	await get_tree().process_frame
	var resources_layer: TileMapLayer = map_layer.resources_layer
	
	## Every child of the resource layer is a tile, a resource scene 
	## that has been painted
	for tile in resources_layer.get_children():
		resource_tiles[tile.position] = tile
		
## Function for initaliazing a building that is gathering a resource
func init_building_gathering(building: Building) -> void:
	if building.building_type != Enums.BuildingType.COAL_POWER_PLANT:
		var resource_tile: GatherableResource = null
		
		if building.position in resource_tiles:
			resource_tile = resource_tiles[building.position]

		var building_type: Enums.BuildingType = building.building_data.building_type
		var building_type_string: String = Enums.building_type_to_string(building_type)

		## Checking if the building is on a resource tile and can gather that resource
		if resource_tile != null and building.can_gather_resource_type == resource_tile.resource_type:
			resource_tiles.get(building.position)
			buildings_gathering.append(building)
			
			var resource_type_string: String = Enums.resource_type_to_string(resource_tile.resource_type)
			
			print(building_type_string + " is gathering " + resource_type_string + " on " + str(building.position))
			
			building.near_resource = true
			## Possible way with timer for gathering resource
			# Start timer for gathering of resource
			# var resource_tile: GatherableResource = resource_tiles[building.position]
			# var resource_quantity: int = resource_tile.gather_resource()
		else:
			building.near_resource = false
			print(building_type_string + " is not gathering on " + str(building.position))
	
## Temporary function for gathering resources
func gather_resources() -> void:
	for building in buildings_gathering:
		var resource_tile: GatherableResource = resource_tiles[building.position]
		var resource_quantity: int = resource_tile.gather_resource()
		# print("Gathered " + str(resource_quantity) + " " + Enums.ResourceType.keys()[resource_tile.resource_type])
