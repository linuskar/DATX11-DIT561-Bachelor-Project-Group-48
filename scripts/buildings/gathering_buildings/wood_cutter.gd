class_name WoodCutter
extends GatheringBuilding
## A class that is for the aspects of a wood cutter.
##
## A class that is for the aspects of an wood cutter. This class extends from
## the GatheringBuilding class.
##

var produced_wood: int = 0
var wood_nearby: int = 0

func _ready():
	super()

## Function to check if the production building is going to overflow with 
## resources in output.
func check_for_output_overflow() -> bool:
	## NOTE: right now it checks for overflow when the total sum 
	## of the next production cycle overflows, i.e. for the total area of resources.
	## Maybe for future, adjust so that if that were the case then the
	## resources to be gathered within the gathering area are selected to a few.
	## Still allowing to get closer to max storage, without overflow
	var wood_gather_rate_per_tile: int = output_generation.get(Enums.ResourceType.WOOD)
	var gather_dict: Dictionary[Vector2, int] = _gather_area(wood_gather_rate_per_tile)
	
	var total_wood_gathered: int = 0
	for wood_gathered in gather_dict.values():
		total_wood_gathered += wood_gathered
		
	var biomass_generated_rate: int = output_generation.get(Enums.ResourceType.BIOMASS)
	var total_biomass_generated: int = total_wood_gathered / biomass_generated_rate
	
	var wood_stored: int = output_storage.get(Enums.ResourceType.WOOD)
	var wood_max_storage: int = max_storage.get(Enums.ResourceType.WOOD)
	
	var biomass_stored: int = output_storage.get(Enums.ResourceType.BIOMASS)
	var biomass_max_storage: int = max_storage.get(Enums.ResourceType.BIOMASS)

	## When at possible overflow of resources for output
	if wood_stored + total_wood_gathered > wood_max_storage or biomass_stored + total_biomass_generated > biomass_max_storage:
		return true
	return false
			
## Function to produce the goods the gathering building can output.
## TODO: probably make it so wood is gathered in the center
func _produce_goods() -> Dictionary[Enums.ResourceType, int]:
	var resources_produced: Dictionary[Enums.ResourceType, int]
	for produced_good in produced_goods:
		var gather_rate_per_tile: int = output_generation.get(produced_good)
		var gather_dict: Dictionary[Vector2, int] = _gather_area(gather_rate_per_tile)
		var produced_good_generated: int = 0

		for resource_pos in resource_tiles_to_gather.keys():
			if is_instance_valid(resource_tiles_to_gather.get(resource_pos)):
				var amount_to_gather: int = gather_dict.get(resource_pos)
				var resource: GatherableResource = resource_tiles_to_gather.get(resource_pos)
				produced_good_generated += resource.gather_resource(amount_to_gather)
				
				if resource.quantity <= 0:
					resource_tiles_to_gather.erase(resource_pos)
			else:
				resource_tiles_to_gather.erase(resource_pos)
				
		## Set the amount of wood produced
		if produced_good == Enums.ResourceType.WOOD:
			produced_wood = produced_good_generated
		
		resources_produced.set(produced_good, produced_good_generated)
		
		if resource_tiles_to_gather.size() == 0:
			near_resource = false
	return resources_produced
			
## Function to generate byproducts for a wood cutter based on wood produced.
func _generate_byproducts() -> void:
	wood_nearby = resource_tiles_to_gather.size()
	for byproduct in byproducts:
		var byproduct_generated_rate: int = output_generation.get(byproduct)
		var byproduct_stored: int = output_storage.get(byproduct)
		var byproduct_generated: int = produced_wood / byproduct_generated_rate
		byproduct_generated = max(byproduct_generated, 1*wood_nearby)
		
		ResourceSignals.add_resource.emit(byproduct, byproduct_generated, self)
		
		if Enums.is_emission(byproduct):
			emitted_emissions.emit(self, byproduct, byproduct_generated)
		else:
			byproduct_stored += byproduct_generated
			output_storage.set(byproduct, byproduct_stored)	
						
## Function to calculate the gather amount in the area around the building
## TODO: probably rework how wood cutter gathers, by starting in the center 
## and then going outwards
func _gather_area(amount: int) -> Dictionary[Vector2, int]:
	var gather_dict: Dictionary[Vector2, int] = {}  
	var grid_size: int = 32
	var gather_radius: int = building_data.gather_radius
	## Iterate around the 2D area (square area) centered on the building,
	## where the area is determined by the gather radius
	for x in range(-gather_radius, gather_radius + 1):
		for y in range(-gather_radius, gather_radius + 1):
			var tile_pos = position + Vector2(x * grid_size, y * grid_size)
			
			## Manhattan distance, grid based
			var distance_from_building: int = abs(x) + abs(y)
			
			## A linear falloff gather rate 
			var amount_to_set: int = amount * (1 - distance_from_building / gather_radius)
			
			## Non zero and no negative values
			amount_to_set = max(amount_to_set, 2)
			gather_dict.set(tile_pos, amount_to_set)
	return gather_dict
