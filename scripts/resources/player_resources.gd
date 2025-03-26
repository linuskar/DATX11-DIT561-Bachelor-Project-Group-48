extends Node

var resources: Dictionary[int, int] = {}
var buildings: Array[ProductionBuilding] = []
var buildings_output: Dictionary[Enums.ResourceType, Array] = {}
var buildings_input: Dictionary[Enums.ResourceType, Array] = {}

#Connect the signals the code will use and initiate a dictonary with a key for each enum with value 0
func _ready() -> void:
	ResourceSignals.add_resource.connect(_new_Resources)
	ResourceSignals.use_resource.connect(_use_Resources)
	for x in Enums.ResourceType.values():
		resources.get_or_add(x, 0)
		buildings_output.get_or_add(x, [])
		buildings_input.get_or_add(x, [])

#Add new amounts for already existing resources
func _new_Resources(type: Enums.ResourceType, amount: int, building: Building) -> void:
	amount += resources.get(type)
	resources.set(type, amount)
	new_building_to_output(building)
	temp(type)
	#Send the new amount to the UI
	ResourceSignals.update_UI.emit(type, resources.get(type))
	
#Remove new amounts for already existing resources
func _use_Resources(type: Enums.ResourceType, amount: int) -> void:
	var newAmount: int = resources.get(type) - amount
	resources.set(type, newAmount)
	#Send the new amount to the UI
	ResourceSignals.update_UI.emit(type, resources.get(type))

#Add buildings placed to the array of buildings
func _on_build_manager_placed_building(building: Building) -> void:
	if building is ProductionBuilding:
		buildings.append(building)
		#new_building_to_output(building)
		new_building_to_input(building)

func new_building_to_output(building: ProductionBuilding) -> void:
	var all_outputs = building.get_produced_resources()
	for output_type in all_outputs:
		var all_output_buildings = buildings_output.get(output_type)
		if !all_output_buildings.has(building):
			all_output_buildings.append(building)
			buildings_output.set(output_type, all_output_buildings)

func new_building_to_input(building: ProductionBuilding) -> void:
	var all_inputs = building.building_data.input_types
	for input_type in all_inputs:
		var all_input_buildings = buildings_input.get(input_type)
		all_input_buildings.append(building)
		buildings_input.set(input_type, all_input_buildings)

func temp(type):
	if buildings_input.get(type).is_empty() == false:
		var next_building: ProductionBuilding = buildings_input.get(type).pop_front()
		var output_building: ProductionBuilding = buildings_output.get(type).pop_front()
		var max_get = output_building.output_storage.get(type)
		var max_input = next_building.max_storage.get(type) - next_building.input_storage.get(type)
		
		if max_input >= max_get:
			output_building._send_resources(type, max_get)
			next_building.add_input_resource(type, max_get)
			print(next_building.input_storage)
			buildings_input.get(type).push_back(next_building)
		else:
			output_building._send_resources(type, max_input)
			next_building.add_input_resource(type, max_input)
			buildings_output.get(type).push_back(output_building)
			temp(type)
