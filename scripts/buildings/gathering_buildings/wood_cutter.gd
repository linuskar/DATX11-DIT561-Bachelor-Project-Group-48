class_name WoodCutter
extends GatheringBuilding
## A class that is for the aspects of a wood cutter.
##
## A class that is for the aspects of an wood cutter. This class extends from
## the GatheringBuilding class.
##

var produced_wood: int = 0

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
	for produced_good in produced_goods:
		var gather_rate_per_tile: int = output_generation.get(produced_good)
		var gather_dict: Dictionary[Vector2, int] = _gather_area(gather_rate_per_tile)
		
		var total_produced_goods_gathered: int = 0
		for value in gather_dict.values():
			total_produced_goods_gathered += value

		var produced_good_stored: int = output_storage.get(produced_good)
		var produced_good_max_storage: int = max_storage.get(produced_good)
		var produced_good_string = Enums.resource_type_to_string(produced_good)
		
		# print(produced_good_string + " to be generated: " + str(total_produced_goods_gathered))
		# print("Current " + produced_good_string + " stored: " + str(produced_good_stored))
		# print("Max storage: " + str(produced_good_max_storage))
		
		## When at possible overflow of resources for output
		if produced_good_stored + total_produced_goods_gathered > produced_good_max_storage:
			return true
	return false
			
## Function to produce the goods the gathering building can output.
func _produce_goods() -> void:
	for produced_good in produced_goods:
		var gather_rate_per_tile: int = output_generation.get(produced_good)
		var produced_good_stored: int = output_storage.get(produced_good)
		var produced_good_generated: int = 0
		
		var gather_dict: Dictionary[Vector2, int] = _gather_area(gather_rate_per_tile)
		
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
			
		produced_good_stored += produced_good_generated
		output_storage.set(produced_good, produced_good_stored)
		ResourceSignals.add_resource.emit(produced_good, produced_good_generated, self)
		
		if resource_tiles_to_gather.size() == 0:
			near_resource = false
			
## Function to generate byproducts for a wood cutter based on wood produced.
func _generate_byproducts() -> void:	
	for byproduct in byproducts:
		var byproduct_generated_rate: int = output_generation.get(byproduct)
		var byproduct_stored: int = output_storage.get(byproduct)
		var byproduct_generated: int = produced_wood / byproduct_generated_rate
				
		ResourceSignals.add_resource.emit(byproduct, byproduct_generated, self)
		if Enums.is_emission(byproduct):
			emitted_emissions.emit(self, byproduct, byproduct_generated)
		else:
			byproduct_stored += byproduct_generated
			output_storage.set(byproduct, byproduct_stored)	
						
## Function to calculate the gather amount in the area around the building
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
			amount_to_set = max(amount_to_set, 1)
			gather_dict.set(tile_pos, amount_to_set)
	return gather_dict
