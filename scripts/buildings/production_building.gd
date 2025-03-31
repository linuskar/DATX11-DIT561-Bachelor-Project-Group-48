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

## The rates/quantity of input resources the production building uses each cycle.
var input_use_rates: Dictionary[Enums.ResourceType, int]
## The rates/quantity of resources the production building outputs each cycle.
var output_generation: Dictionary[Enums.ResourceType, int] 

## The timer representing the production cycle of a production building.
@onready var production_cycle: Timer = $Timer

## Signal for when emissions are emitted
signal emitted_emissions(building: Building, emission_type: Enums.ResourceType, amount: int)

func _ready() -> void:
	super()
	init_production_building()
	
## Function to initialize the production building.
func init_production_building() -> void:
	input_use_rates = building_data.input_use_rates
		
	output_generation = building_data.output_generation
	
## Activated at the end of each cycle.
func _on_timer_timeout() -> void:
	_output_resources()
	
## Function to begin outputting resources from the production building.
func _output_resources() -> void:
	if !check_if_can_produce():
		# print("Can't produce")
		production_cycle.stop()
	else:
		var building_type_string: String = Enums.building_type_to_string(building_data.building_type)
		# print(building_type_string + " is producing")
		_produce_goods()
		_use_input_recipe()
		_generate_byproducts()

## Function to check if the production building can produce.
func check_if_can_produce() -> bool:
	var missing_input: bool = check_for_missing_input()
	var can_be_output_overflow: bool = check_for_output_overflow()
	
	if missing_input:
		return false
		
	if can_be_output_overflow:
		return false
	
	return true
	
## Function to check if the production building is going to overflow with 
## resources in output.
func check_for_output_overflow() -> bool:
	for produced_good in produced_goods:
		var produced_good_generated: int = output_generation.get(produced_good)
		var produced_good_stored: int = output_storage.get(produced_good)
		var produced_good_max_storage: int = max_storage.get(produced_good)
		var produced_good_string = Enums.resource_type_to_string(produced_good)
		
		# print(produced_good_string + " to be generated: " + str(produced_good_generated))
		# print("Current " + produced_good_string + " stored: " + str(produced_good_stored))
		# print("Max storage: " + str(produced_good_max_storage))
		
		## When at possible overflow of resources for output
		if produced_good_stored + produced_good_generated > produced_good_max_storage:
			return true
	return false
		
## Function to check if the production building is missing resources for input
## to produce.
func check_for_missing_input() -> bool:
	for input in input_storage:
		var input_quantity: int = input_storage.get(input)
		var input_use_rate: int = input_use_rates.get(input)
		
		if input_quantity < input_use_rate:
			return true
	return false
	
## Function to produce the goods the building can output.
func _produce_goods() -> void:
	for produced_good in produced_goods:
		var produced_good_generated: int = output_generation.get(produced_good)
		var produced_good_stored: int = output_storage.get(produced_good)
		var produced_good_max_storage: int = max_storage.get(produced_good)
		
		produced_good_stored += produced_good_generated
		output_storage.set(produced_good, produced_good_stored)
		ResourceSignals.add_resource.emit(produced_good, produced_good_generated)
		
## Function to use the resources from input in a production building.
func _use_input_recipe() -> void:
	for input in input_storage:
		var input_quantity: int = input_storage.get(input)
		var input_use_rate: int = input_use_rates.get(input)
		var input_left: int = input_quantity - input_use_rate
		
		if input_left <= 0:
			input_left = 0
			
		input_storage.set(input, input_left)
		
## Function to generate byproducts from a production building.
func _generate_byproducts() -> void:
	for byproduct in byproducts:
		var byproduct_generated: int = output_generation.get(byproduct)
		ResourceSignals.add_resource.emit(byproduct, byproduct_generated)
		
		if Enums.is_emission(byproduct):
			emitted_emissions.emit(self, byproduct, byproduct_generated)
	
## Function to send resources away from this buildings output storage.
func _send_resources(resource_type: Enums.ResourceType, amount: int) -> void:
	var resource_quantity: int = output_storage.get(resource_type)
	output_storage.set(resource_type, resource_quantity - amount)
	
	if check_if_can_produce():
		production_cycle.autostart = true
	
## Function to add resources to the storage building.
func add_input_resource(input_type: Enums.ResourceType, input_amount: int) -> void:
	var current: int = input_storage.get(input_type)
	input_storage.set(input_type, current + input_amount)
