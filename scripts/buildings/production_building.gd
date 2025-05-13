class_name ProductionBuilding
extends StorageBuilding
## A class that is for aspects of a production building
##
## A class that is for aspects of a production building, containing it's
## metadata. The main functionallity is about producing a resource with
## other potential resources as input.
## This class extends from the StorageBuilding class.
##
##

## The nodes emitting smoke.
@export var smokes: Array[GPUParticles2D]

## The rates/quantity of input resources the production building uses each cycle.
var input_use_rates: Dictionary[Enums.ResourceType, int]
## The rates/quantity of resources the production building outputs each cycle.
var output_generation: Dictionary[Enums.ResourceType, int] 

## The timer representing the production cycle of a production building.
@onready var production_cycle: Timer = $Timer

## The mode the building is currently in, default is storing
var mode: Enums.ProductionBuildingMode = Enums.ProductionBuildingMode.STORING

## The valid input recipes to produce
var input_recipes: Dictionary[int, InputRecipe]

## Signal for when emissions are emitted
signal emitted_emissions(building: Building, emission_type: Enums.ResourceType, amount: int)

func _ready() -> void:
	super()
	PlayerCurrency.currency_changed.connect(restart_operation)
	init_production_building()
	init_smoke()

## Function for initializing the smoke emitting
func init_smoke() -> void:
	for smoke in smokes:
		smoke.z_index = 1
		smoke.emitting = false

## Function for emitting smoke when possible.
func emit_smoke() -> void:
	if check_if_can_produce() == false or PlayerCurrency.player_held_currency < self.building_data.building_upkeep:
		for smoke in smokes:
			smoke.emitting = false
	else:
		for smoke in smokes:
			smoke.emitting = true

## Function to initialize the production building.
func init_production_building() -> void:
	input_use_rates = building_data.input_use_rates
	output_generation = building_data.output_generation
	init_input_recipes()
	
## Function to initialize the input recipes, this is done due to how
## Godot does not support nested arrays that are typed
func init_input_recipes() -> void:
	for id in building_data.input_recipes.keys():
		var recipe: Array = building_data.input_recipes.get(id)
		
		for resource_type in recipe:
			if input_recipes.has(id):
				var input_recipe: InputRecipe = input_recipes.get(id)
				input_recipe.resources.append(resource_type)
				input_recipes.set(id, input_recipe)
			else:
				var new_array: InputRecipe = InputRecipe.new()
				new_array.resources.append(resource_type)
				input_recipes.set(id, new_array)

## Activated at the end of each cycle.
func _on_timer_timeout() -> void:
	_output_resources()

## Function to begin outputting resources from the production building.
func _output_resources() -> void:
	emit_smoke() 
	if !check_if_can_produce() or PlayerCurrency.player_held_currency < self.building_data.building_upkeep:
		production_cycle.paused = true
	elif mode == Enums.ProductionBuildingMode.PAUSED:
		pause_operations()
	else:
		#var building_type_string: String = Enums.building_type_to_string(building_data.building_type)
		_use_input_recipe()
		_handle_produced_goods()
		_generate_byproducts()

func _handle_produced_goods() -> void:
	var produced_resources: Dictionary[Enums.ResourceType, int] = _produce_goods()
	for resource in produced_resources.keys():
		match mode:
			Enums.ProductionBuildingMode.STORING:
				output_storage.set(resource, output_storage.get(resource)+produced_resources.get(resource))
				ResourceSignals.add_resource.emit(resource, produced_resources.get(resource), self)
				resources_changed.emit(resource, produced_resources.get(resource))
			Enums.ProductionBuildingMode.SELLING:
				PlayerCurrency.add_currency(Enums.get_value_of_resource(resource)*produced_resources.get(resource))
	PlayerCurrency.remove_currency(self.building_data.building_upkeep)
	
## Function to check if the production building can produce.
func check_if_can_produce() -> bool:
	if check_for_missing_input():
		return false
	
	if check_for_production_overflow() and not mode ==  Enums.ProductionBuildingMode.SELLING:
		return false
	
	if check_for_byproduct_overflow():
		return false
	
	return true

func check_for_production_overflow() -> bool:
	for produced_good in produced_goods:
		var produced_good_generated: int = output_generation.get(produced_good)
		var produced_good_stored: int = output_storage.get(produced_good)
		var produced_good_max_storage: int = max_storage.get(produced_good)
		
		## When at possible overflow of resources for output
		if produced_good_stored + produced_good_generated > produced_good_max_storage:
			return true
	return false
	
func check_for_byproduct_overflow() -> bool:
	for byproduct in byproducts:
		if !Enums.is_emission(byproduct):
			var byproduct_generated: int = output_generation.get(byproduct)
			var byproduct_stored: int = output_storage.get(byproduct)
			var byproduct_max_storage: int = max_storage.get(byproduct)
			if byproduct_stored + byproduct_generated > byproduct_max_storage:
				return true
	return false

## Function to check if the production building is going to overflow with 
## resources in output.
func check_for_output_overflow() -> bool:
	for produced_good in produced_goods:
		var produced_good_generated: int = output_generation.get(produced_good)
		var produced_good_stored: int = output_storage.get(produced_good)
		var produced_good_max_storage: int = max_storage.get(produced_good)
		
		## When at possible overflow of resources for output
		if produced_good_stored + produced_good_generated > produced_good_max_storage:
			return true
			
	for byproduct in byproducts:
		if !Enums.is_emission(byproduct):
			var byproduct_generated: int = output_generation.get(byproduct)
			var byproduct_stored: int = output_storage.get(byproduct)
			var byproduct_max_storage: int = max_storage.get(byproduct)
			if byproduct_stored + byproduct_generated > byproduct_max_storage:
				return true
	return false

## Function to check if the production building is missing resources for input
## to produce.
func check_for_missing_input() -> bool:
	var recipes_invalid: int = 0
	
	for input_recipe in input_recipes.values():
		for input in input_recipe.resources:
			var input_quantity: int = input_storage.get(input)
			var input_use_rate: int = input_use_rates.get(input)
			
			if input_quantity < input_use_rate:
				recipes_invalid += 1
				break
				
		if recipes_invalid == input_recipes.size():
			return true
	return false
	
## Function to produce the goods the building can output. Returns a dictionary
## containing every produced good and the amount that was produced
func _produce_goods() -> Dictionary[Enums.ResourceType, int]:
	var resources_produced: Dictionary[Enums.ResourceType, int]
	for produced_good in produced_goods:
		resources_produced.set(produced_good, output_generation.get(produced_good))
	return resources_produced

## Function to use the resources from input in a production building.
func _use_input_recipe() -> void:
	for input_recipe in input_recipes.values():
		for input in input_recipe.resources:
			var input_quantity: int = input_storage.get(input)
			var input_use_rate: int = input_use_rates.get(input)
			var input_left: int = input_quantity - input_use_rate
			
			if input_left <= 0:
				input_left = 0
				
			input_storage.set(input, input_left)
			
	## Request input after using recipe
	if input_storage.size() != 0:
		ResourceSignals.add_input_building.emit(self)
		
## Function to generate byproducts from a production building.
func _generate_byproducts() -> void:
	for byproduct in byproducts:
		var byproduct_generated: int = output_generation.get(byproduct)
		var byproduct_stored: int = output_storage.get(byproduct)

		ResourceSignals.add_resource.emit(byproduct, byproduct_generated, self)
		
		if Enums.is_emission(byproduct):
			emitted_emissions.emit(self, byproduct, byproduct_generated)
		else:
			byproduct_stored += byproduct_generated
			output_storage.set(byproduct, byproduct_stored)
			resources_changed.emit(byproduct, byproduct_generated)
	
## Function to send resources away from this buildings output storage.
func _send_resources(resource_type: Enums.ResourceType, amount: int) -> void:
	var resource_quantity: int = output_storage.get(resource_type)
	output_storage.set(resource_type, resource_quantity - amount)
	resources_changed.emit(resource_type, -amount)
	if check_if_can_produce():
		production_cycle.paused = false

func add_input_resource(input_type: Enums.ResourceType, input_amount: int) -> void:
	var current = input_storage.get(input_type)
	input_storage.set(input_type, current + input_amount)
	
	if check_if_can_produce():
		production_cycle.paused = false
		
	ResourceSignals.use_resource.emit(input_type, input_amount)

## Function that checks whether there is enough currency to restart operation
func restart_operation() -> void:
	if not PlayerCurrency.player_held_currency < self.building_data.building_upkeep:
		production_cycle.paused = false

## Function for checking whether the building can continue producing
func check_restart_production() -> void:
	emit_smoke() 
	if !check_if_can_produce() or PlayerCurrency.player_held_currency < self.building_data.building_upkeep:
		production_cycle.paused = true
	else:
		production_cycle.paused = false

## Function for pausing the operations of a building
func pause_operations() -> void:
	pause_smokes()
	production_cycle.paused = true

## Function for pausing smoke emissions
func pause_smokes() -> void:
	for smoke in smokes:
		smoke.emitting = false
