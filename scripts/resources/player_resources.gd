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
	#var new_networks = BuildManagerGlobal.road_networks
	##Logic for when the nr of networks is the same
	#if new_networks.size() == networks.size():
		#same_nr_networks(new_networks)
	##Logic for when the new network is 1 bigger
	#elif new_networks.size() == networks.size() + 1:
		#new_network(new_networks)
	##Logic for when one or more networks merge
	#else:
		#var nr_merged_networks = networks.size() - new_networks.size()
	##TODO Logic whether to add building to existing resource_transport instance or create a new
	#for current_network in buildings.keys():
		#if !networks.has(current_network):
			#new_network(buildings.get(current_network))
		#var new_network = buildings.get(current_network)
		#var old_network = networks.get(current_network).buildings
	#Temporary solution
	if BuildManagerGlobal.nr_adjacent_buildings >= 2:
		join_networks()
	if building is not StorageBuilding:
		return
	print(BuildManagerGlobal.nr_adjacent_buildings)
	if BuildManagerGlobal.nr_adjacent_buildings == 0:
		new_network(BuildManagerGlobal.current_new_network_id, building)
	elif BuildManagerGlobal.nr_adjacent_buildings == 1:
		add_to_existing_network(building)
	

func join_networks():
	if !networks.has(BuildManagerGlobal.first):
		networks.get_or_add(BuildManagerGlobal.first, preload("res://scripts/resources/resource_transport.gd").new())
	for current_network in BuildManagerGlobal.current_networks:
		networks.get(BuildManagerGlobal.first).add_another_network(networks.get(current_network))
		networks.erase(current_network)

func add_to_existing_network(building):
	if networks.get(BuildManagerGlobal.current_networks.get(0)) == null:
		new_network(BuildManagerGlobal.current_networks.get(0), building)
	else:
		networks.get(BuildManagerGlobal.current_networks.get(0)).new_building(building)

func same_nr_networks(new_networks):
	for current_key in new_networks.key():
		var new_network = new_networks.get(current_key).duplicate().sort()
		var old_network = networks.get(current_key).buildings.duplicate().sort()
		if new_network == old_network:
			continue
		for current_building in new_network:
			if old_network.has(current_building):
				continue
			networks.get(current_key).new_building(current_building)
			break
		

func new_network(network_id, building) -> void:
	networks.get_or_add(network_id, preload("res://scripts/resources/resource_transport.gd").new())
	networks.get(network_id).new_building(building)

func new_building_to_output(building: StorageBuilding) -> void:
	##TODO Logic to send new_building_to_output to the correct instance
	for temp in networks.keys():
		if networks.get(temp).buildings.has(building):
			networks.get(temp).new_building_to_output(building)
	##Temp solution
	#networks.get(0).new_building_to_output(building)

func new_building_to_input(building: StorageBuilding) -> void:
	##TODO Logic to send new_building_to_input to the correct instance
	for temp in networks.keys():
		if networks.get(temp).buildings.has(building):
			networks.get(temp).new_building_to_input(building)
	##Temp solution
	#networks.get(0).new_building_to_input(building)

func temp(type) -> void:
	for current_network in networks.values():
		current_network.transport_resources(type)


func _on_timer_timeout() -> void:
	print("Current networks, ", networks)
	for key in resources.keys():
		temp(key)
