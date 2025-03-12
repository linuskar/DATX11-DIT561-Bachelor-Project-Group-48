class_name ProductionBuilding
extends Building

var max_storage: Dictionary[Enums.ResourceType, int]
var input_storage: Dictionary[Enums.ResourceType, int]
var input_use_rates: Dictionary[Enums.ResourceType, int]
var output_storage: Dictionary[Enums.ResourceType, int] 
var output_generation: Dictionary[Enums.ResourceType, int] 

var emissions: Array[Enums.ResourceType]
var produced_goods: Array[Enums.ResourceType]

var can_produce: bool

@onready var production_cycle: Timer = $Timer

func _ready() -> void:
	super()
	max_storage = building_data.max_storage
	
	for resource in building_data.input_type:
		input_storage.set(resource, 0)
		
	input_use_rates = building_data.input_use_rates
	
	for resource in building_data.output_type:
		output_storage.set(resource, 0)
		
	output_generation = building_data.output_generation

	for output in output_generation.keys():
		if Enums.is_emission(output) == true:
			emissions.append(output)
		elif Enums.is_produced_good(output) == true:
			produced_goods.append(output)

	# Connect the signal that can take resources from this building
	ResourceSignals.get_resource.connect(_send_resources)

func check_if_can_produce() -> bool:
	var missing_input: bool = check_for_missing_input()
	var can_be_output_overflow: bool = check_for_output_overflow()
	
	if missing_input:
		return false
		
	if can_be_output_overflow:
		return false
	
	return true
	
func check_for_missing_input() -> bool:
	var missing_input: bool = false
	
	for input in input_storage:
		var input_quantity: int = input_storage.get(input)
		var input_use_rate: int = input_use_rates.get(input)
		
		if input_quantity < input_use_rate:
			missing_input = true
			
	return missing_input

func check_for_output_overflow() -> bool:
	var output_overflow: bool = true
	
	for produced_good in produced_goods:
		var produced_good_generated: int = output_generation.get(produced_good)
		var produced_good_stored: int = output_storage.get(produced_good)
		var produced_good_max_storage: int = max_storage.get(produced_good)
		var produced_good_string = Enums.resource_type_to_string(produced_good)
		print(produced_good_string + " to be generated: " + str(produced_good_generated))
		print("Current " + produced_good_string + " stored: " + str(produced_good_stored))
		print("Max storage: " + str(produced_good_max_storage))
		
		## If at max output
		if produced_good_stored + produced_good_generated <= produced_good_max_storage:
			output_overflow = false
			break
			
	return output_overflow
	
## Activated at the end of each cycle
func _on_timer_timeout() -> void:
	_output_resources()
	
## Output the resources to the storage and emit what have been created
## Production buildings have inputs for resources to use in their output
func _output_resources() -> void:
	can_produce = check_if_can_produce()
	if can_produce == false:
		print("Can't produce")
		production_cycle.stop()
	else:
		var building_type_string: String = Enums.building_type_to_string(building_data.building_type)
		print(building_type_string + " is producing")
		_produce_goods()
		_use_input_recipe()	
		_generate_waste_and_emissions()	
		
func _produce_goods() -> void:
	for produced_good in produced_goods:
		var produced_good_generated: int = output_generation.get(produced_good)
		var produced_good_stored: int = output_storage.get(produced_good)
		var produced_good_max_storage: int = max_storage.get(produced_good)
		
		produced_good_stored += produced_good_generated
		output_storage.set(produced_good, produced_good_stored)
		ResourceSignals.add_resource.emit(produced_good, produced_good_stored)
			
func _use_input_recipe() -> void:
	## The amount of input resources used in a cycle
	for input in input_storage:
		var input_quantity: int = input_storage.get(input)
		var input_use_rate: int = input_use_rates.get(input)
		var input_left: int = input_quantity - input_use_rate
		
		if input_left <= 0:
			input_left = 0
		
		input_storage.set(input, input_left)
		
func _generate_waste_and_emissions() -> void:
	## The amount of emissions/waste created from a cycle
	for emission in emissions:
		var emission_generated: int = output_generation.get(emission)
		ResourceSignals.add_resource.emit(emission, emission_generated)
	
## Send resources away from this buildings storage
func _send_resources(resource_type: Enums.ResourceType, amount: int) -> void:
	var resource_quantity: int = output_storage.get(resource_type)
	output_storage.set(resource_type, resource_quantity - 1)
	
	if can_produce:
		production_cycle.autostart = true
