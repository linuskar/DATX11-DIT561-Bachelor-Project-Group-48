extends  Node

var connected_buildings: Dictionary[Vector2, Building]

var occupied_tiles: Dictionary[Vector2, Building]

#placed road positions.
static var road_positions: Array[Vector2]

signal update_roads

var road_networks: Dictionary[int, Array] = {}  # { network_id: Set of building(not roads) positions(Vector2) }
var road_to_network: Dictionary[Vector2, int] = {}  # { road_position: network_id }

var networks: Dictionary[int, Array] = {}
var current_new_network_id: int = 0
var sibling_positions = []
var sibling_positions_1 = [Vector2(-32, 0), Vector2(32, 0), Vector2(0, 32), Vector2(0, -32)]
var current_sibling: Array[Building] = []
var current_networks: Array[int] = []
var nr_adjacent_buildings: int
var temp: int
var first: int


#Updates road_networks with a network_id key to a list of the buildings positions.
func update_networks(building: Building):
	current_sibling.clear()
	#Find all siblings
	sibling_positions = get_adjacent_tiles_centered(building.building_data.building_size)
	print(sibling_positions)
	for sibling in sibling_positions:
		current_sibling.append(get_sibling(sibling, building))
	
	#Save the networks
	nr_adjacent_buildings = 0
	current_networks.clear()
	
	for sibling in current_sibling:
		if sibling == null:
			continue
		temp = get_network(sibling)
		if !current_networks.has(temp):
			current_networks.append(temp)
			nr_adjacent_buildings += 1
	
	if nr_adjacent_buildings == 0:
		create_new_network(building)
	elif nr_adjacent_buildings == 1:
		add_to_existing_network(current_networks.get(0), building)
	elif nr_adjacent_buildings >= 2:
		join_networks()

func get_adjacent_tiles_centered(size: Vector2) -> Array:
	var tile_size := 32
	var offsets := []

	var half_w := size.x / 2.0
	var half_h := size.y / 2.0

	# Top and bottom edges
	for x in range(size.x):
		var offset_x = (x - half_w + 0.5) * tile_size
		offsets.append(Vector2(offset_x, -half_h * tile_size - tile_size/2))  # top
		offsets.append(Vector2(offset_x, half_h * tile_size + tile_size/2))   # bottom

	# Left and right edges
	for y in range(size.y):
		var offset_y = (y - half_h + 0.5) * tile_size
		offsets.append(Vector2(-half_w * tile_size - tile_size/2, offset_y))  # left
		offsets.append(Vector2(half_w * tile_size + tile_size/2, offset_y))   # right

	return offsets

func get_network(building: Building) -> int:
	for key in networks:
		if networks.get(key).has(building):
			return key
	return -1

func create_new_network(building: Building):
	current_new_network_id += 1
	networks.get_or_add(current_new_network_id, [building])
	print("Current network: ", networks.get(current_new_network_id))
	

func add_to_existing_network(network_key: int, building: Building):
	print("Current key: ", network_key)
	networks.get(network_key).append(building)

func join_networks():
	first = current_networks.pop_back()
	for current_network_id in current_networks:
		networks.get(first).append_array(networks.get(current_network_id))
		networks.erase(current_network_id)
	

func get_sibling(pos: Vector2, building: Building) -> Building: #Returns building or null.
	var target_pos: Vector2 = building.position + pos
	return occupied_tiles.get(target_pos, null)
	
	#var visited = {}
	#road_networks.clear()
	#road_to_network.clear()
	#current_network_id = 0
	#
	##
	#for road_pos in road_positions:
		#if not visited.get(road_pos, false):
			#current_network_id += 1
			#var network_buildings: Dictionary[Vector2, Building] = {}
			#_flood_fill_network(road_pos, visited, network_buildings)
			#
			## Convert to Set to automatically handle duplicates
			#road_networks[current_network_id] = network_buildings.keys()

func print_networks() -> void:
	print("===== NETWORKS =====")
	for network_id in networks:
		print("Network ", network_id, " buildings:")
		for building_pos in networks[network_id]:
			var building = occupied_tiles.get(building_pos)
			print("  - ", building, " at ", building_pos)
	print("===================")

#func _flood_fill_network(pos, visited, buildings) -> void:
	#if visited.get(pos, false) or not occupied_tiles.has(pos):
		#return
		#
	#visited[pos] = true
	#var road = occupied_tiles[pos]
	#road_to_network[pos] = current_network_id
	#
	## Check adjacent buildings
	#for dir in [Vector2.LEFT*32, Vector2.RIGHT*32, Vector2.UP*32, Vector2.DOWN*32]:
		#var neighbor_pos: Vector2 = pos + dir
		#if occupied_tiles.has(neighbor_pos):
			#var neighbor: Building = occupied_tiles[neighbor_pos]
			#if neighbor.building_type != Enums.BuildingType.ROAD:
				#buildings.get_or_add(neighbor_pos, neighbor)
			#else:
				#_flood_fill_network(neighbor_pos, visited, buildings)
