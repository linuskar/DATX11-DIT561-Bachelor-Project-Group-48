class_name ProductionBuilding
extends Building

var max_storage: Dictionary[Enums.ResourceType, int]
var input_storage: Dictionary[Enums.ResourceType, int]
var input_use_rates: Dictionary[Enums.ResourceType, int]
var output_storage: Dictionary[Enums.ResourceType, int] 
var output_generation: Dictionary[Enums.ResourceType, int] 

var emissions: Array[Enums.ResourceType]
var produced_goods: Array[Enums.ResourceType]

var is_missing_input: bool
var is_at_full_output_storage: bool

func _ready() -> void:
	max_storage = building_data.max_storage
	input_storage = building_data.input_storage
	input_use_rates = building_data.input_use_rates
	output_storage = building_data.output_storage
	output_generation = building_data.output_generation
	
	for output in output_generation.keys():
		if Enums.is_emission(output) == true:
			emissions.append(output)
		elif Enums.is_produced_good(output):
			produced_goods.append(output)
			
	is_missing_input = check_for_missing_input()
	is_at_full_output_storage = check_if_can_produce()
			
	# Connect the signal that can take resources from this building		
	ResourceSignals.get_resource.connect(_send_resources)
	
## Activated at the end of each cycle
func _on_timer_timeout() -> void:
	_output_resources()
	
func check_for_missing_input() -> bool:
	var missing_input: bool = false
	
	for input in input_storage:
		var input_quantity: int = input_storage.get(input)
		var input_use_rate: int = input_use_rates.get(input)
		
		if input_quantity < input_use_rate:
			missing_input = true
			
	return missing_input

func check_if_can_produce() -> bool:
	var can_produce: bool = true
	
	for produced_good in produced_goods:
		var produced_good_generated: int = output_generation.get(produced_good)
		var produced_good_stored: int = output_storage.get(produced_good)
		var produced_good_max_storage: int = max_storage.get(produced_good)
		
		## If at max output
		if produced_good_stored + produced_good_generated <= produced_good_max_storage:
			can_produce = false
			break
		
	return can_produce

## Output the resources to the storage and emit what have been created
## Production buildings have inputs for resources to use in their output
func _output_resources() -> void:
	is_missing_input = check_for_missing_input()
	is_at_full_output_storage = check_if_can_produce()
	
	if is_missing_input == false or is_at_full_output_storage == false:
		_produce_goods()
		_use_input_recipe()	
		_generate_waste_and_emissions()
	else:
		$Timer.stop()
		
func _produce_goods() -> void:
	for produced_good in produced_goods:
		var produced_good_generated: int = output_generation.get(produced_good)
		var produced_good_stored: int = output_storage.get(produced_good)
		var produced_good_max_storage: int = max_storage.get(produced_good)
		
		produced_good_stored += produced_good_generated
		ResourceSignals.add_resource.emit(produced_good, produced_good_generated)
			
func _use_input_recipe() -> void:
	## The amount of input resources used in a cycle
	for input in input_storage:
		var input_quantity: int = input_storage.get(input)
		var input_use_rate: int = input_use_rates.get(input)
		var input_left: int = input_quantity - input_use_rate
		
		if input_left <= 0:
			input_left = 0
			is_missing_input = true
		
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
	
	is_at_full_output_storage = check_if_can_produce()
	
	if is_at_full_output_storage:
		$Timer.autostart()	
