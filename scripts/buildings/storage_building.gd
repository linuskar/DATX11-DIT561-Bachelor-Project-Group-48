class_name StorageBuilding
extends Building
## A class that is for aspects of a storage building
##
## A class that is for aspects of a storage building, containing it's
## metadata. The main functionallity is about storing resources.
## This class extends from the Building class.
##
##

## The max storage of the resources the production building interacts with.
var max_storage: Dictionary[Enums.ResourceType, int]
## The input and its storage of the resources the building stores.
var input_storage: Dictionary[Enums.ResourceType, int]
## The storage of the resources the building sends.
var output_storage: Dictionary[Enums.ResourceType, int] 

## The byproducts the storage building takes in and outputs.
var byproducts: Array[Enums.ResourceType]
## The produced goods the storage building takes in and outputs.
var produced_goods: Array[Enums.ResourceType]

func _ready() -> void:
	super()
	init_storage_building()
	
## Function to initialize the storage building.
## Note: Input and output are the same for a building who only stores resources
func init_storage_building() -> void:
	max_storage = building_data.max_storage
	print(max_storage)
	
	for resource in building_data.input_types:
		input_storage.set(resource, 0)
			
	for resource in building_data.output_types:
		output_storage.set(resource, 0)
		
	for output in output_storage.keys():
		if Enums.is_byproduct(output) == true:
			byproducts.append(output)
		elif Enums.is_produced_good(output) == true:
			produced_goods.append(output)
			
	# Connect the signal that can take resources from this building
	ResourceSignals.get_resource.connect(_send_resources)
	
## Function to send resources away from this buildings output storage.
func _send_resources(resource_type: Enums.ResourceType, amount: int) -> void:
	var resource_quantity: int = output_storage.get(resource_type)
	output_storage.set(resource_type, resource_quantity - amount)
	
	input_storage.set(resource_type, resource_quantity - amount)
	
func get_produced_resources() -> Array[Enums.ResourceType]:
	var arr: Array[Enums.ResourceType] = []
	for product in byproducts:
		if !Enums.is_emission(product):
			arr.append(product)
	var all_resource_output = arr + produced_goods
	return all_resource_output
	
## Function to add resources to the storage building.
func add_input_resource(input_type: Enums.ResourceType, input_amount: int) -> void:
	var current: int = input_storage.get(input_type)
	input_storage.set(input_type, current + input_amount)
	output_storage.set(input_type, current + input_amount)
	ResourceSignals.use_resource.emit(input_type, input_amount)
	ResourceSignals.add_resource.emit(input_type, input_amount, self)
