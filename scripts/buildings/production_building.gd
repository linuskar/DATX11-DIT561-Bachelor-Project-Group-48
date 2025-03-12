class_name ProductionBuilding
extends Building

@export var max_storage: Dictionary[Enums.ResourceType, int]
@export var input_storage: Dictionary[Enums.ResourceType, int]
@export var input_use_rates: Dictionary[Enums.ResourceType, int]
@export var output_storage: Dictionary[Enums.ResourceType, int] 
@export var output_generation: Dictionary[Enums.ResourceType, int] 

var emissions: Array[Enums.ResourceType]
var produced_goods: Array[Enums.ResourceType]
var is_missing_input: bool

func _ready():
	for output in output_storage.keys():
		if Enums.is_emission(output) == true:
			emissions.append(output)
		elif Enums.is_produced_good(output):
			produced_goods.append(output)
			
	is_missing_input = check_for_missing_input()
			
	# Connect the signal that can take resources from this building		
	ResourceSignals.get_resource.connect(_send_resources)

func check_for_missing_input() -> bool:
	var is_missing_input: bool = false
	
	for input in input_storage:
		var input_quantity: int = input_storage.get(input)
		var input_use_rate: int = input_use_rates.get(input)
		
		if input_quantity < input_use_rate:
			is_missing_input = true
			
	return is_missing_input
	
## Activated at the end of each cycle
func _on_timer_timeout() -> void:
	output_resources()

## Output the resources to the storage and emit what have been created
## Production buildings have inputs for resources to use in their output
func output_resources() -> void:
	if is_missing_input == false:
		## The amount of input resources used in a cycle
		for input in input_storage:
			var input_quantity: int = input_storage.get(input)
			var input_used: int = input_use_rates.get(input)
			var input_left: int = input_quantity - input_used
			
			if input_left < 0:
				input_left = 0
				is_missing_input = true
			
			input_storage.set(input, input_left)
		
		## The amount of emissions/waste created from a cycle
		for emission in emissions:
			var emission_generated: int = output_generation.get(emission)
			ResourceSignals.add_resource.emit(emission, emission_generated)
		
		## The amount of produced goods created from a cycle
		## TODO: look at timer?
		for produced_good in produced_goods:
			var produced_good_generated: int = output_generation.get(produced_good)
			var produced_good_stored: int = output_storage.get(produced_good)
			var produced_good_max_storage: int = max_storage.get(produced_good)
			
			if produced_good_stored + produced_good_generated <= produced_good_max_storage:
				produced_good_stored += produced_good_generated
				ResourceSignals.add_resource.emit(produced_good, produced_good_generated)
			else:
				$Timer.stop()

## Send resources away from this buildings storage
func _send_resources(resource_type: Enums.ResourceType, amount: int) -> void:
	for resource in output_storage.keys():
		if resource_type == resource:
			var resource_quantity: int = output_storage.get(resource_type)
			output_storage.set(resource_type, resource_quantity - 1)
		
	## TODO: timer start when every quantity has decreases/has capacity to produce		
	$Timer.autostart()	
