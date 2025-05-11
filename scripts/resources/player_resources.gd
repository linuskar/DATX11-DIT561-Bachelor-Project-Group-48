class_name PlayerResources
extends Node

static var resources: Dictionary[Enums.ResourceType, int] = {}
var networks: Dictionary[int, ResourceTransport] = {}

#Connect the signals the code will use and initiate a dictonary with a key for each enum with value 0
func _ready() -> void:
	ResourceSignals.add_resource.connect(_new_Resources)
	ResourceSignals.use_resource.connect(_use_Resources)
	ResourceSignals.add_input_building.connect(new_building_to_input)
	for x in Enums.ResourceType.values():
		resources.get_or_add(x, 0)

#Add new amounts for already existing resources
func _new_Resources(type: Enums.ResourceType, amount: int, building: Building) -> void:
	amount += resources.get(type)
	resources.set(type, amount)
	new_building_to_output(building)
	#Send the new amount to the UI
	ResourceSignals.update_UI.emit(type, resources.get(type))
	
#Remove new amounts for already existing resources
func _use_Resources(type: Enums.ResourceType, amount: int) -> void:
	var new_amount: int = resources.get(type) - amount
	resources.set(type, new_amount)
	#Send the new amount to the UI
	ResourceSignals.update_UI.emit(type, resources.get(type))
						
func check_if_resource_amount_is_stored(resource: Enums.ResourceType, amount_needed: int) -> bool:
	if resources.has(resource):
		var current_amount: int = resources.get(resource)
		if current_amount >= amount_needed:
			return true
	return false
		
## Function to use resources and "buy" with them.
## This function takes into account all the building that has resoruces
## in their output storage. Resources will be used in a building if the amount is satisfied.
## NOTE: This function assumes the required amount of a resource is already met.
func buy_with_resources(type: Enums.ResourceType, amount_needed: int, buildings_to_use: Array[StorageBuilding]) -> void:
	var amount_needed_left: int = amount_needed
	
	for building in buildings_to_use:
		if building.output_storage.has(type):
			if amount_needed_left == 0:
				return
			
			var output_stored: int = building.output_storage.get(type)
			## If the resources needed are there.
			if output_stored > 0:
				## If the amount needed is greater than the resources stored in the building
				if amount_needed_left > output_stored:
					## Take all the resources in the output storage for the building
					_use_Resources(type, output_stored)
					building.output_storage.set(type, output_stored - output_stored)
					amount_needed_left -= output_stored
				## If the amount needed is less or equal to the resources stored in the building
				else:
					## Take some parts of the resources in the output storage for the building
					_use_Resources(type, amount_needed_left)
					building.output_storage.set(type, output_stored - amount_needed_left)
					amount_needed_left -= amount_needed_left

func get_network_for_building(building_to_check: StorageBuilding) -> ResourceTransport:
	for network in networks.values():
		for building in network.buildings:
			if building == building_to_check:
				return network
	return null

func check_resource_amount_in_network(type: Enums.ResourceType, amount_needed: int, network: ResourceTransport) -> bool:
	var amount_needed_left: int = amount_needed

	for building in network.buildings:
		if building.output_storage.has(type):		
			var output_stored: int = building.output_storage.get(type)
			## If the resources needed are there.
			if output_stored > 0:
				## If the amount needed is greater than the resources stored in the building
				if amount_needed_left > output_stored:
					amount_needed_left -= output_stored
				## If the amount needed is less or equal to the resources stored in the building
				else:
					amount_needed_left -= amount_needed_left
	return not amount_needed_left

#Add buildings placed to the array of buildings
func _on_build_manager_placed_building(building: Building) -> void:
	#Case of two or more adjacent networks
	if BuildManagerGlobal.nr_adjacent_networks >= 2:
		join_networks(building)
	
	#Case of no adjacent networks, creates new network
	elif BuildManagerGlobal.nr_adjacent_networks == 0:
		new_network(BuildManagerGlobal.current_new_network_id, building)
	
	if building is not StorageBuilding:
		return
	
	#Case of one adjacent network, adds building to existing network
	if BuildManagerGlobal.nr_adjacent_networks == 1:
		add_to_existing_network(building)

#Joins networks into the last network (Already poped in BuildManagerGlobal) in the list current_networks
func join_networks(building: Building): 
	for current_network in BuildManagerGlobal.current_networks:
		networks.get(BuildManagerGlobal.first).add_another_network(networks.get(current_network))
		networks.erase(current_network)
	if building is StorageBuilding:
		networks.get(BuildManagerGlobal.first).new_building(building)

#Add a building into an existing network
func add_to_existing_network(building):
	if networks.get(BuildManagerGlobal.current_networks.get(0)) == null:
		new_network(BuildManagerGlobal.current_networks.get(0), building)
	else:
		networks.get(BuildManagerGlobal.current_networks.get(0)).new_building(building)

#Creates a new network with building in it if it is a StorageBuilding
func new_network(network_id, building) -> void:
	networks.get_or_add(network_id, preload("res://scripts/resources/resource_transport.gd").new())
	if building is StorageBuilding:
		networks.get(network_id).new_building(building)

func new_building_to_output(building: StorageBuilding) -> void:
	for temp in networks.keys():
		if networks.get(temp).buildings.has(building):
			networks.get(temp).new_building_to_output(building)

func new_building_to_input(building: StorageBuilding) -> void:
	for temp in networks.keys():
		if networks.get(temp).buildings.has(building):
			networks.get(temp).new_building_to_input(building)

#Transport resources
func _on_timer_timeout() -> void:
	for type in resources.keys():
		for current_network in networks.values():
			current_network.transport_resources(type)

## Checks whether the player has a certain amount of the given resourcetype
## Return true if the player has the required amount and false otherwise
func check_player_has_resource(resource: Enums.ResourceType, amount: int) -> bool:
	return resources.get(resource) and resources.get(resource) >= amount
