extends  Node

var connected_buildings: Dictionary[Vector2, Building]

var occupied_tiles: Dictionary[Vector2, Building]

#placed road positions.
static var road_positions: Array[Vector2]

signal update_roads

var road_networks: Dictionary[int, Array] = {}  # { network_id: Set of building(not roads) positions(Vector2) }
var road_to_network: Dictionary[Vector2, int] = {}  # { road_position: network_id }
var current_network_id: int = 0

#Updates road_networks with a network_id key to a list of the buildings positions.
func update_networks() -> void:
	#Clears the old networks to begin creating new ones.
	var visited: Dictionary[Vector2, bool] = {}
	road_networks.clear()
	road_to_network.clear()
	current_network_id = 0
	
	#
	for road_pos in road_positions:
		if not visited.get(road_pos, false):
			current_network_id += 1
			var network_buildings: Dictionary[Vector2, Building] = {}
			_flood_fill_network(road_pos, visited, network_buildings)
			
			# Convert to Set to automatically handle duplicates
			road_networks[current_network_id] = network_buildings.keys()

func print_networks() -> void:
	print("===== NETWORKS =====")
	for network_id in road_networks:
		print("Network ", network_id, " buildings:")
		for building_pos in road_networks[network_id]:
			var building = occupied_tiles.get(building_pos)
			print("  - ", building, " at ", building_pos)
	print("===================")

func _flood_fill_network(pos, visited, buildings) -> void:
	if visited.get(pos, false) or not occupied_tiles.has(pos):
		return
		
	visited[pos] = true
	var road = occupied_tiles[pos]
	road_to_network[pos] = current_network_id
	
	# Check adjacent buildings
	for dir in [Vector2.LEFT*32, Vector2.RIGHT*32, Vector2.UP*32, Vector2.DOWN*32]:
		var neighbor_pos: Vector2 = pos + dir
		if occupied_tiles.has(neighbor_pos):
			var neighbor: Building = occupied_tiles[neighbor_pos]
			if neighbor.building_type != Enums.BuildingType.ROAD:
				buildings.get_or_add(neighbor_pos, neighbor)
			else:
				_flood_fill_network(neighbor_pos, visited, buildings)
	
	# Flood fill to connected roads
	#for dir in [Vector2.LEFT*32, Vector2.RIGHT*32, Vector2.UP*32, Vector2.DOWN*32]:
		#var neighbor_pos: Vector2 = pos + dir
		#if occupied_tiles.has(neighbor_pos):
			#var neighbor: Building = occupied_tiles[neighbor_pos]
			#if neighbor.building_type == Enums.BuildingType.ROAD:
				
