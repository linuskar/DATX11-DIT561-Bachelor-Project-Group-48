extends  Node

var connected_buildings: Dictionary[Vector2, Building]

var occupied_tiles: Dictionary[Vector2, Building]

static var road_positions: Array[Vector2]

signal update_roads

var road_networks = {}  # { network_id: Set of building positions }
var road_to_network = {}  # { road_position: network_id }
var current_network_id = 0

func update_networks():
	var visited = {}
	road_networks.clear()
	road_to_network.clear()
	current_network_id = 0
	
	for road_pos in road_positions:
		if not visited.get(road_pos, false):
			current_network_id += 1
			var network_buildings = {}
			_flood_fill_network(road_pos, visited, network_buildings)
			
			# Convert to Set to automatically handle duplicates
			road_networks[current_network_id] = network_buildings.keys()

func print_networks():
	print("===== NETWORKS =====")
	for network_id in road_networks:
		print("Network ", network_id, " buildings:")
		for building_pos in road_networks[network_id]:
			var building = occupied_tiles.get(building_pos)
			print("  - ", building, " at ", building_pos)
	print("===================")

func _flood_fill_network(pos, visited, buildings):
	if visited.get(pos, false) or not occupied_tiles.has(pos):
		return
		
	visited[pos] = true
	var road = occupied_tiles[pos]
	road_to_network[pos] = current_network_id
	
	# Check adjacent buildings
	for dir in [Vector2.LEFT*32, Vector2.RIGHT*32, Vector2.UP*32, Vector2.DOWN*32]:
		var neighbor_pos = pos + dir
		if occupied_tiles.has(neighbor_pos):
			var neighbor = occupied_tiles[neighbor_pos]
			if neighbor.building_type != Enums.BuildingType.ROAD:
				buildings[neighbor_pos] = neighbor
	
	# Flood fill to connected roads
	for dir in [Vector2.LEFT*32, Vector2.RIGHT*32, Vector2.UP*32, Vector2.DOWN*32]:
		var road_pos = pos + dir
		if occupied_tiles.has(road_pos):
			var neighbor = occupied_tiles[road_pos]
			if neighbor.building_type == Enums.BuildingType.ROAD:
				_flood_fill_network(road_pos, visited, buildings)
