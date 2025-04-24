extends Node

var resources: Dictionary[int, int] = {}
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
	var newAmount: int = resources.get(type) - amount
	resources.set(type, newAmount)
	#Send the new amount to the UI
	ResourceSignals.update_UI.emit(type, resources.get(type))

#Add buildings placed to the array of buildings
func _on_build_manager_placed_building(building) -> void:
	#Case of two or more adjacent networks
	if BuildManagerGlobal.nr_adjacent_buildings >= 2:
		join_networks()
	
	#Case of no adjacent networks, creates new network
	elif BuildManagerGlobal.nr_adjacent_buildings == 0:
		new_network(BuildManagerGlobal.current_new_network_id, building)
	
	if building is not StorageBuilding:
		return
	
	#Case of one adjacent network, adds building to existing network
	if BuildManagerGlobal.nr_adjacent_buildings == 1:
		add_to_existing_network(building)

#Joins networks into the last network (Already poped in BuildManagerGlobal) in the list current_networks
func join_networks(): 
	for current_network in BuildManagerGlobal.current_networks:
		networks.get(BuildManagerGlobal.first).add_another_network(networks.get(current_network))
		networks.erase(current_network)

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
