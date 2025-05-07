extends  Node

var connected_buildings: Dictionary[Vector2, Building]

var occupied_tiles: Dictionary[Vector2, Building]

#placed road positions.
static var road_positions: Array[Vector2]

signal update_roads

var networks: Dictionary[int, Array] = {} #key is the network id, value is an array of buildings
var current_new_network_id: int = 0 #The current network id
var sibling_positions = [] #The relative position of all neighbours
var current_sibling: Array[Building] = [] #Array of all neightbours
var current_networks: Array[int] = [] #Array of all neighbour network ids
var nr_adjacent_networks: int #Number of adjacent buildings
var first: int #The network other networks join into

var tile_size: int = 32 #Size of tiles

## The buildings in the game that are currently placed.
var buildings_placed: Array[Building]

func get_all_storage_buildings() -> Array[StorageBuilding]:
	var storage_buildings: Array[StorageBuilding] = []
	
	for buidling in buildings_placed:
		storage_buildings.append(buidling)
		
	return storage_buildings

#Updates road_networks with a network_id key to a list of the buildings positions.
func update_networks(building: Building) -> void:
	#Find all sibling
	current_sibling.clear()
	get_adjacent_tiles_centered(building.building_data.building_size)
	for sibling in sibling_positions:
		current_sibling.append(get_sibling(sibling, building))
	
	#Save the networks of adjacent buildings
	nr_adjacent_networks = 0
	current_networks.clear()
	
	for sibling in current_sibling:
		if sibling == null:
			continue
		var adjacent_network = get_network(sibling)
		if !current_networks.has(adjacent_network):
			current_networks.append(adjacent_network)
			nr_adjacent_networks += 1
	
	#Case of no adjacent networks, creates new network
	if nr_adjacent_networks == 0:
		create_new_network(building)
	
	#Case of one adjacent network, adds building to existing network
	elif nr_adjacent_networks == 1:
		add_to_existing_network(current_networks.get(0), building)
	
	#Case of two or more adjacent networks
	elif nr_adjacent_networks >= 2:
		join_networks(building)

#Find the relativ position of all adjacent tiles
func get_adjacent_tiles_centered(size: Vector2) -> void: 
	sibling_positions.clear()
	
	var half_w := size.x / 2.0
	var half_h := size.y / 2.0

	# Top and bottom edges
	for x in range(size.x):
		var offset_x = (x - half_w + 0.5) * tile_size
		sibling_positions.append(Vector2(offset_x, -half_h * tile_size - tile_size/2))  # top
		sibling_positions.append(Vector2(offset_x, half_h * tile_size + tile_size/2))   # bottom

	# Left and right edges
	for y in range(size.y):
		var offset_y = (y - half_h + 0.5) * tile_size
		sibling_positions.append(Vector2(-half_w * tile_size - tile_size/2, offset_y))  # left
		sibling_positions.append(Vector2(half_w * tile_size + tile_size/2, offset_y))   # right

#Return the network id for the network a building is in
func get_network(building: Building) -> int: 
	for key in networks:
		if networks.get(key).has(building):
			return key
	
	#Should never happen, if it does there is a bug
	return -1

#Creates a new network with building in it
func create_new_network(building: Building) -> void: 
	current_new_network_id += 1
	networks.get_or_add(current_new_network_id, [building])

#Add a building into an existing network
func add_to_existing_network(network_key: int, building: Building) -> void: 
	networks.get(network_key).append(building)

#Joins networks into the last network in the list current_networks
func join_networks(building) -> void: 
	first = current_networks.pop_back()
	for current_network_id in current_networks:
		networks.get(first).append_array(networks.get(current_network_id))
		networks.get(first).append(building)
		networks.erase(current_network_id)
	
#Returns the adjacent building or null
func get_sibling(pos: Vector2, building: Building) -> Building: 
	var target_pos: Vector2 = building.position + pos
	return occupied_tiles.get(target_pos, null)
