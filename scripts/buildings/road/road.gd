extends Building

static var road_positions: Array[Vector2] = BuildManagerGlobal.road_positions

var occupied_tiles: Dictionary[Vector2, Building] = BuildManagerGlobal.occupied_tiles
var left: bool = false
var right: bool = false
var up: bool = false
var down: bool = false

# Cache sibling references
var sibling_left: Building = null
var sibling_right: Building = null
var sibling_down: Building = null
var sibling_up: Building = null

func _ready():
	$place_animation.play("place")
	super()
	BuildManagerGlobal.update_roads.connect(update_connections)
	
	road_positions.append(position)
	
#Remove position when deleted.
func _exit_tree():
	road_positions.erase(position)
	BuildManagerGlobal.update_roads.emit()
	
#Gets the sibling/neighboring tile.
func get_sibling(pos: Vector2) -> Building: #Returns building or null.
	var target_pos: Vector2 = position + pos
	return BuildManagerGlobal.occupied_tiles.get(target_pos, null)

func check_if_road_or_building(pos: Vector2):
	var target_pos = position + pos
	return occupied_tiles.has(target_pos)

func check_if_building(pos: Vector2):
	var target_pos = position + pos
	if occupied_tiles.has(target_pos):
		var building = occupied_tiles[target_pos]
		if building.building_type != Enums.BuildingType.ROAD:
			register_building_connection(building)
			return true
	return false

#Adds the buldings that are connected to a road to a list.
func register_building_connection(building: Building) -> void:
	BuildManagerGlobal.connected_buildings[position] = building

#Recursively goes through all roads and checks if they have siblings and see if they are buildings or roads and returns them.
func find_connected_buildings(parent: Building = null, visited: Dictionary[Vector2, bool] = {}) -> Array[Building]:
	var buildings: Array[Building] = []
	
	# Mark current road as visited to prevent infinite loops.
	visited[position] = true
	
	# Check all four directions.
	for dir in [Vector2.LEFT * 32, Vector2.RIGHT * 32, Vector2.UP * 32, Vector2.DOWN * 32]:
		var sibling: Building = get_sibling(dir)
		
		#Check to see that the sibling doesn't go backwards and the path is not visited already.
		if sibling and sibling != parent and not visited.get(sibling.position, false):
			if sibling.building_type != Enums.BuildingType.ROAD:
				buildings.append(sibling)
			else:
				# Recursively search through connected roads.
				buildings += sibling.find_connected_buildings(self, visited)
	
	return buildings

#Use the function find_connected_buildings and adds them to a list.
func check_network_connections() -> Array[Building]: #returning list of type Building or null.
	var connected_buildings: Array[Building] = find_connected_buildings()
	return connected_buildings

#Returns the roads connected to the network_id in a list
func get_network_buildings() -> Array[Vector2]:
	#if BuildManagerGlobal.road_to_network.has(position):
	var network_id: int = BuildManagerGlobal.road_to_network[position]
	return BuildManagerGlobal.road_networks.get(network_id, [])
	
#Updates booleans sprites and siblings.
func update_connections() -> void:
	# Update directional connections.

	# Update sibling references.
	sibling_left = get_sibling(Vector2(-32, 0))
	sibling_right = get_sibling(Vector2(32, 0))
	sibling_up = get_sibling(Vector2(0, -32))
	sibling_down = get_sibling(Vector2(0, 32))

	left = sibling_left != null
	right = sibling_right != null
	up = sibling_up != null
	down = sibling_down != null
	
	# Update visual connections.
	update_road_sprite()
	# Check network connections
	check_network_connections()

#Updates road sprites.
func update_road_sprite() -> void:
	
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
		


func _on_place_animation_animation_finished(anim_name: StringName) -> void:
	$place_particle.emitting = true
