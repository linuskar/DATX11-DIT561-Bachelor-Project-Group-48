class_name Road
extends ProductionBuilding

static var road_positions: Array[Vector2] = []

var occupied_tiles = BuildManagerGlobal.occupied_tiles

var left: bool = false
var right: bool = false
var up: bool = false
var down: bool = false

func _ready():
	BuildManagerGlobal.update_roads.connect(update_connections)
	road_positions.append(position)
	super()

func _process(delta: float) -> void:
	pass

func check_if_building(pos: Vector2):
	return BuildManagerGlobal.occupied_tiles.has(position + pos)

func check_if_connection():
	pass
func update_connections():
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
		
		
