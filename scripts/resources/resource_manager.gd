class_name ResourceManager
extends Node
## A class that manages the resources of the game
##
## A class that manages the resources of the game and any 
##
##

@onready var map_layer: MapLayer = $"../MapLayer"
@onready var build_manager: BuildManager = $"../BuildManager"
@onready var pollution_manager: PollutionManager = $"../PollutionManager"

## The buildings that are currently gathering resources
var buildings_gathering: Array[Building]

## A dictionary containing the tiles with gatherable resoruces on the map
var resource_tiles: Dictionary[Vector2, GatherableResource] = {}
var grid_size: int = 32

func _ready() -> void:
	build_manager.placed_building.connect(init_building_gathering)
	pollution_manager.emissions_to_apply.connect(apply_emissions)
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
	if Enums.is_gathering_building(building.building_type):
		if building is WoodCutter:
			## For gathering in an area around the building
			var gather_radius: int = building.building_data.gather_radius
			_init_gather_area(-gather_radius, gather_radius+1, -gather_radius, gather_radius+1, building.position, building)
		else:
			## For gathering on the tiles the building is on
			var adjusted_pos: Vector2 = building.position 
			var building_tile_size: Vector2 = building.building_data.building_size
			adjusted_pos -= Vector2(grid_size * (building_tile_size.x - 1) / 2, 0)
			adjusted_pos -= Vector2(0, grid_size * (building_tile_size.y -  1) / 2)
			
			_init_gather_area(0, building_tile_size.x, 0, building_tile_size.y, adjusted_pos, building)

## Function to get the tiles in the area around the building to gather
func _init_gather_area(min_x: int, max_x: int, min_y: int, max_y: int, start_pos: Vector2, building: Building) -> void:
	var gather_area_dict: Dictionary[Vector2, GatherableResource] = {}  
	## Iterate around the area centered to be gathered on
	for x in range(min_x, max_x):
		for y in range(min_y, max_y):
			var tile_pos = start_pos + Vector2(x * grid_size, y * grid_size)
			if is_instance_valid(resource_tiles.get(tile_pos)):
				var resource_tile: GatherableResource = resource_tiles.get(tile_pos)
				
				if resource_tile != null and building.can_gather_resource_type == resource_tile.resource_type:
					gather_area_dict.set(tile_pos, resource_tile)
					building.near_resource = true
	building.resource_tiles_to_gather = gather_area_dict
	if building is WoodCutter:
		building.sort_resource_tiles_to_gather()
	
## Function to apply emissions on resource tiles
func apply_emissions(emissions_dict: Dictionary[Vector2, float], emission_type: Enums.ResourceType) -> void:
	for pos in emissions_dict.keys():
		var amount_to_apply: float = emissions_dict.get(pos)
		## Avoiding resources that have been deleted from memory
		if resource_tiles.has(pos) and is_instance_valid(resource_tiles.get(pos)):
			var gatherable_resource: GatherableResource = resource_tiles.get(pos)
			
			if gatherable_resource is GatherableTree:
				gatherable_resource.absorb_emission(emission_type, amount_to_apply)
				pollution_manager.set_emissions_absorbed(emission_type, amount_to_apply)
				pollution_manager.set_emissions_not_absorbed(emission_type, -amount_to_apply)
