extends Node

var resources: Dictionary[int, int] = {}
var networks: Array[ResourceTransport] = [preload("res://scripts/resources/resource_transport.gd").new()]

#Connect the signals the code will use and initiate a dictonary with a key for each enum with value 0
func _ready() -> void:
	ResourceSignals.add_resource.connect(_new_Resources)
	ResourceSignals.use_resource.connect(_use_Resources)
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
func _on_build_manager_placed_building(building: Building) -> void:
	##TODO Logic whether to add building to existing resource_transport instance or create a new
	
	#Temporary solution
	if building is ProductionBuilding:
		networks.get(0).new_building(building)

func new_building_to_output(building: ProductionBuilding) -> void:
	##TODO Logic to send new_building_to_output to the correct instance
	
	##Temp solution
	networks.get(0).new_building_to_output(building)

func new_building_to_input(building: ProductionBuilding) -> void:
	##TODO Logic to send new_building_to_input to the correct instance
	
	##Temp solution
	networks.get(0).new_building_to_input(building)

func temp(type) -> void:
	for current_network in networks:
		current_network.transport_resources(type)


func _on_timer_timeout() -> void:
	for key in resources.keys():
		temp(key)

func join_two_networks():
	##TODO join two different networks into one, call add_another_network() in resource_transport.gd
	pass
