class_name ResourceTransport
extends Node

#All buildings in the network
var buildings: Array[ProductionBuilding] = []
#All buildings having more than 0 of a specific resource
var buildings_output: Dictionary[Enums.ResourceType, Array] = {}
#All buildings looking for a specific resource
var buildings_input: Dictionary[Enums.ResourceType, Array] = {}

func _init() -> void:
	for x in Enums.ResourceType.values():
		buildings_output.get_or_add(x, [])
		buildings_input.get_or_add(x, [])
		
#Add building to buildings
func new_building(building: ProductionBuilding) -> void:
	buildings.append(building)
	new_building_to_input(building)
	
#Add building to output every time the building produce resource when it had 0 before
func new_building_to_output(building: ProductionBuilding) -> void:
	if !buildings.has(building):
		return
	var all_outputs = building.get_produced_resources()
	for output_type in all_outputs:
		var all_output_buildings = buildings_output.get(output_type)
		if !all_output_buildings.has(building):
			all_output_buildings.append(building)
			buildings_output.set(output_type, all_output_buildings)

#As long as a building input storage isn't 0
func new_building_to_input(building: ProductionBuilding) -> void:
	var all_inputs = building.building_data.input_types
	for input_type in all_inputs:
		var all_input_buildings = buildings_input.get(input_type)
		if !all_input_buildings.has(building):
			all_input_buildings.append(building)
			buildings_input.set(input_type, all_input_buildings)

#Flyttar resources från byggnader i output_buildings till byggnader i input_buildings
func transport_resources(type: Enums.ResourceType) -> void:
	if !buildings_input.get(type).is_empty() && !buildings_output.get(type).is_empty():
		var next_building: ProductionBuilding = buildings_input.get(type).pop_front()
		var output_building: ProductionBuilding = buildings_output.get(type).pop_front()
		var max_get = output_building.output_storage.get(type)
		var max_input = next_building.max_storage.get(type) - next_building.input_storage.get(type)
		
		if max_input >= max_get:
			output_building._send_resources(type, max_get)
			next_building.add_input_resource(type, max_get)
			#Temp solution
			buildings_input.get(type).push_back(next_building)
			##TODO logic for priority buildings, (push front/push back)
			
			transport_resources(type)
		else:
			output_building._send_resources(type, max_input)
			next_building.add_input_resource(type, max_input)
			#Temp solution
			buildings_output.get(type).push_back(output_building)
			##TODO logic for priority buildings, (push front/push back)
			
			transport_resources(type)
		return

#Doesn't work atm
#Join two different networks into one, the new_network ahould be delete after this 
func add_another_network(new_network: ResourceTransport):
	buildings.append_array(new_network.buildings)
	buildings_input.merge(new_network.buildings_input)
	buildings_input.merge(new_network.buildings_output)
