class_name ResourceManager
extends Node
## A class that manages the resources of the game
##
## A class that manages the resources of the game and any 
##
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
	if building is WoodCutter:
		_init_gather_area(building)
	elif Enums.is_gathering_building(building.building_type):
		var resource_tile: GatherableResource = null
		
		if building.position in resource_tiles:
			resource_tile = resource_tiles[building.position]

		var building_type: Enums.BuildingType = building.building_data.building_type
		var building_type_string: String = Enums.building_type_to_string(building_type)
		if resource_tile != null and building.can_gather_resource_type == resource_tile.resource_type:
			buildings_gathering.append(building)
			
			var resource_type_string: String = Enums.resource_type_to_string(resource_tile.resource_type)
			
			# print(building_type_string + " is gathering " + resource_type_string + " on " + str(building.position))
			building.resoures_tiles_to_gather.append(resource_tile)
			# resoures_tiles_to_gather.set(,resource_tile)
			building.near_resource = true
		else:
			building.near_resource = false
			# print(building_type_string + " is not gathering on " + str(building.position))
			
## Function to get the tiles in the area around the building to gather
func _init_gather_area(building: Building) -> void:
	var gather_dict: Dictionary[Vector2, GatherableResource] = {}  
	var grid_size: int = 32
	var gather_radius: int = 1
	
	if Enums.is_gathering_building(building.building_type):
		## Iterate around the 2D area centered on the building,
		## where the area is determined by the gather_radius radius
		for x in range(-gather_radius, gather_radius + 1):
			for y in range(-gather_radius, gather_radius + 1):
				var tile_pos = building.position + Vector2(x * grid_size, y * grid_size)
				if is_instance_valid(resource_tiles.get(tile_pos)):
					var resource_tile: GatherableResource = resource_tiles.get(tile_pos)
					
					if resource_tile != null and building.can_gather_resource_type == resource_tile.resource_type:
						gather_dict.set(tile_pos, resource_tile)
						building.near_resource = true
						
	building.gather_area_dict = gather_dict
			
