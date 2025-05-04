class_name WoodCutter
extends GatheringBuilding
## A class that is for the aspects of a wood cutter.
##
## A class that is for the aspects of an wood cutter. This class extends from
## the GatheringBuilding class.
##

var resource_to_gather_queue: Array = []
var current_tree_gathering: GatherableTree = null
var wood_gathered: int = 0

func _ready():
	super()
	apply_research_upgrade()
	Research.research_completed.connect(_on_research_completed)
	$place_animation.play("place")

## Function to begin outputting resources from the production building.
func _output_resources() -> void:
	if !check_if_can_produce() or PlayerCurrency.player_held_currency < self.building_data.building_upkeep:
		production_cycle.paused = true
		if current_tree_gathering != null:
			current_tree_gathering.gathering_sprite_2d.hide()
	else:
		var building_type_string: String = Enums.building_type_to_string(building_data.building_type)
		_handle_produced_goods()
		_use_input_recipe()
		_generate_byproducts()
	
## Function to check if the production building is going to overflow with 
## resources in output.
func check_for_output_overflow() -> bool:
	var wood_gather_rate_per_tile: int = output_generation.get(Enums.ResourceType.WOOD)
	
	var wood_gather_rate: int = output_generation.get(Enums.ResourceType.WOOD)
		
	var biomass_generated_rate: int = output_generation.get(Enums.ResourceType.BIOMASS)
	
	var wood_stored: int = output_storage.get(Enums.ResourceType.WOOD)
	var wood_max_storage: int = max_storage.get(Enums.ResourceType.WOOD)
	
	var biomass_stored: int = output_storage.get(Enums.ResourceType.BIOMASS)
	var biomass_max_storage: int = max_storage.get(Enums.ResourceType.BIOMASS)

	## When at possible overflow of resources for output
	if wood_stored + wood_gather_rate > wood_max_storage or biomass_stored + biomass_generated_rate > biomass_max_storage:
		return true
	return false
			
## Function to produce the goods the gathering building can output.
func _produce_goods() -> Dictionary[Enums.ResourceType, int]:
	var resources_produced: Dictionary[Enums.ResourceType, int]
	
	for produced_good in produced_goods:
		var gather_rate_per_tile: int = output_generation.get(produced_good)
		
		if current_tree_gathering == null and resource_to_gather_queue.size() != 0:
			if is_instance_valid(resource_to_gather_queue[0]):
				current_tree_gathering = resource_to_gather_queue.pop_front()
			else:
				resource_to_gather_queue.pop_front()
		## Producing wood
		if is_instance_valid(current_tree_gathering):
			$wood_chop_sound.pitch_scale = randf_range(0.75, 1.5)
			$wood_chop_sound.play()
			
			current_tree_gathering.gathering_sprite_2d.show()

			wood_gathered = current_tree_gathering.gather_resource(output_generation.get(Enums.ResourceType.WOOD))
			if current_tree_gathering.quantity <= 0:
				current_tree_gathering = null

		resources_produced.set(produced_good, wood_gathered)
		
		if resource_to_gather_queue.size() == 0 and current_tree_gathering == null:
			near_resource = false
			
	return resources_produced
	
## Function to sort resources for the wood cutter be gathered, one at a time.
func sort_resource_tiles_to_gather() -> void:
	var resource_positions: Array[Vector2] = resource_tiles_to_gather.keys()
	resource_to_gather_queue = []
	
	## Sort resource positons in a manner that makes
	## the queue start at the center, and then outwards
	resource_positions.sort_custom(func(a, b):
		return a.distance_squared_to(position) < b.distance_squared_to(position)
	)
	
	## Add the order in how the wood cutter gathers
	for resource_position in resource_positions:
		resource_to_gather_queue.append(resource_tiles_to_gather.get(resource_position))
	
## Function to generate byproducts for a wood cutter based on wood produced.
func _generate_byproducts() -> void:
	if wood_gathered <= 0:
		return
		
	for byproduct in byproducts:
		var byproduct_generated_rate: int = output_generation.get(byproduct)
		var byproduct_stored: int = output_storage.get(byproduct)
		
		ResourceSignals.add_resource.emit(byproduct, byproduct_generated_rate, self)

		if Enums.is_emission(byproduct):
			emitted_emissions.emit(self, byproduct, byproduct_generated_rate)
		else:
			byproduct_stored += byproduct_generated_rate
			output_storage.set(byproduct, byproduct_stored)
			resources_changed.emit(byproduct, byproduct_generated_rate)

func _on_place_animation_animation_finished(anim_name: StringName) -> void:
	$place_particle.emitting = true

func _on_research_completed(id: String) -> void:
	apply_research_upgrade()

func apply_research_upgrade() -> void:
	if Research.has_completed("WC1"):
		pass
