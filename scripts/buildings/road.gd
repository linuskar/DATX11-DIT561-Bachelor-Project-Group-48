class_name Road
extends ProductionBuilding

static var road_positions: Array[Vector2] = []

var occupied_tiles = BuildManagerGlobal.occupied_tiles

var left: bool = false
var right: bool = false
var up: bool = false
var down: bool = false

var road_path: Path2D = BuildManagerGlobal.create_path()

func _ready():
	BuildManagerGlobal.update_roads.connect(update_connections)
	road_positions.append(position)
	super()

func _process(delta: float) -> void:
	pass

#Pos is a position to the left, right up and down (+-)32 pixels.
func check_if_building(pos: Vector2):
	if BuildManagerGlobal.occupied_tiles.has(position + pos):
		check_if_connection(pos)
		return true
	else: return false

func check_solids():
	pass

#Check if the building that is next to the road is not a road than it should save that to a list.
func check_if_connection(pos: Vector2):
	if BuildManagerGlobal.occupied_tiles[position + pos].building_type != Enums.BuildingType.ROAD:
		BuildManagerGlobal.connected_buildings[position] = BuildManagerGlobal.occupied_tiles[position + pos]
		modulate = Color(0, 1, 0, 1)
		print("Connection!: " + str(BuildManagerGlobal.connected_buildings[position]) + " at position!: " + str(position))
		
#Check if there is something that the road should visually connect to
func update_connections():
	#road_path.curve.add_point(position)
	left = check_if_building(Vector2(-32, 0))
	right = check_if_building(Vector2(32, 0))
	up = check_if_building(Vector2(0, -32))
	down = check_if_building(Vector2(0, 32))

	# Check if there is a building next to a road
	
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
		
