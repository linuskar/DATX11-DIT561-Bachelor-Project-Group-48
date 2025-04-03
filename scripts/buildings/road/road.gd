extends ProductionBuilding

static var road_positions: Array[Vector2] = BuildManagerGlobal.road_positions

var occupied_tiles = BuildManagerGlobal.occupied_tiles
var left: bool = false
var right: bool = false
var up: bool = false
var down: bool = false

# Cache sibling references
var sibling_left = null
var sibling_right = null
var sibling_down = null
var sibling_up = null

func _ready():
	BuildManagerGlobal.update_roads.connect(update_connections)
	road_positions.append(position)
	super()

func _exit_tree():
	road_positions.erase(position)
	BuildManagerGlobal.update_roads.emit()

func get_sibling(pos: Vector2):
	var target_pos = position + pos
	if BuildManagerGlobal.occupied_tiles.has(target_pos):
		return BuildManagerGlobal.occupied_tiles[target_pos]
	return null

func check_if_road_or_building(pos: Vector2):
	var target_pos = position + pos
	return BuildManagerGlobal.occupied_tiles.has(target_pos)



func check_if_building(pos: Vector2):
	var target_pos = position + pos
	if BuildManagerGlobal.occupied_tiles.has(target_pos):
		var building = BuildManagerGlobal.occupied_tiles[target_pos]
		if building.building_type != Enums.BuildingType.ROAD:
			register_building_connection(building)
			return true
	return false

func register_building_connection(building):
	BuildManagerGlobal.connected_buildings[position] = building
	modulate = Color(0, 1, 0, 1)

func find_connected_buildings(parent = null, visited = {}):
	var buildings = []
	
	# Mark current road as visited to prevent infinite loops
	visited[position] = true
	
	# Check all four directions
	for dir in [Vector2.LEFT * 32, Vector2.RIGHT * 32, Vector2.UP * 32, Vector2.DOWN * 32]:
		var sibling = get_sibling(dir)
		
		if sibling and sibling != parent and not visited.get(sibling.position, false):
			if sibling.building_type != Enums.BuildingType.ROAD:
				buildings.append(sibling)
			else:
				# Recursively search through connected roads
				buildings += sibling.find_connected_buildings(self, visited)
	
	return buildings

var road_networks = []
func check_network_connections():
	var connected_buildings = find_connected_buildings()
	if connected_buildings.size() > 0:
		modulate = Color(0, 1, 0, 1)  # Green if connected to buildings
		
	else:
		modulate = Color(1, 1, 1, 1)  # White if not connected
		
	return connected_buildings

func get_network_buildings():
	if BuildManagerGlobal.road_to_network.has(position):
		var network_id = BuildManagerGlobal.road_to_network[position]
		return BuildManagerGlobal.road_networks.get(network_id, [])
	return []

func update_connections():
	# Update directional connections
	left = check_if_road_or_building(Vector2(-32, 0))
	right = check_if_road_or_building(Vector2(32, 0))
	up = check_if_road_or_building(Vector2(0, -32))
	down = check_if_road_or_building(Vector2(0, 32))

	# Update sibling references
	sibling_left = get_sibling(Vector2(-32, 0))
	sibling_right = get_sibling(Vector2(32, 0))
	sibling_up = get_sibling(Vector2(0, -32))
	sibling_down = get_sibling(Vector2(0, 32))

	# Update visual connections
	update_road_sprite()
	
	# Check network connections
	check_network_connections()
	
	BuildManagerGlobal.update_networks()
	var my_buildings = get_network_buildings()

func update_road_sprite():
	
	if up and down and left and right:
		$Sprite2D.frame = 2  # Fully connected crossroad
	elif up and left and down:
		$Sprite2D.frame = 1  # T-junction (right open)
	elif up and right and down:
		$Sprite2D.frame = 7  # T-junction (left open)
	elif left and right and down:
		$Sprite2D.frame = 10  # T-junction (top open)
	elif left and right and up:
		$Sprite2D.frame = 11  # T-junction (bottom open)
	elif left and right:
		$Sprite2D.frame = 4  # Horizontal road
	elif up and down:
		$Sprite2D.frame = 3  # Vertical road
	elif right and down:
		$Sprite2D.frame = 5  # Top-left corner
	elif left and down:
		$Sprite2D.frame = 6  # Top-right corner
	elif right and up:
		$Sprite2D.frame = 8  # Bottom-left corner
	elif left and up:
		$Sprite2D.frame = 9  # Bottom-right corner
	elif left or right:
		$Sprite2D.frame = 4  # Default horizontal
	elif up or down:
		$Sprite2D.frame = 3  # Default vertical
		
