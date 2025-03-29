class_name Road
extends ProductionBuilding

static var road_positions: Array[Vector2] = []

var left: bool = false
var right: bool = false
var up: bool = false
var down: bool = false

func _ready():
	road_positions.append(position)
	super()
	update_connections()

func _process(delta: float) -> void:
	update_connections()
	
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

func update_connections():
	left = road_positions.has(position + Vector2(-32, 0))
	right = road_positions.has(position + Vector2(32, 0))
	up = road_positions.has(position + Vector2(0, -32))
	down = road_positions.has(position + Vector2(0, 32))
