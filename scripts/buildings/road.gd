class_name Road
extends ProductionBuilding

static var road_positions: Array[Vector2] = []

const TRUCK = preload("res://scenes/test_truck/truck.tscn")

var left: bool = false
var right: bool = false
var up: bool = false
var down: bool = false

var astargrid2d = ResourceSignals.astargrid2d

func _ready():
	StateManager.update_road.connect(update_roads)
	astargrid2d.cell_size = Vector2i(32, 32)
	astargrid2d.region = Rect2i(0, 0, 1000, 1000)
	astargrid2d.default_compute_heuristic = AStarGrid2D.HEURISTIC_EUCLIDEAN
	astargrid2d.default_estimate_heuristic = AStarGrid2D.HEURISTIC_EUCLIDEAN
	astargrid2d.diagonal_mode = AStarGrid2D.DIAGONAL_MODE_NEVER
	astargrid2d.update()
	
	for x in range(astargrid2d.size.x):
		for y in range(astargrid2d.size.y):
			if is_road_tile(Vector2i(x, y)):
				astargrid2d.set_point_solid(Vector2i(x, y), false)
			else:
				astargrid2d.set_point_solid(Vector2i(x, y), true)
			update_connections()
	
	var truck_instance = TRUCK.instantiate()
	truck_instance.position = position
	get_parent().add_child(truck_instance)
	
	road_positions.append(position)
	super()

func _process(delta: float) -> void:
	update_connections()
	
	if up and down and left and right:
		$Sprite2D.frame = 2
	elif up and left and down:
		$Sprite2D.frame = 1
	elif up and right and down:
		$Sprite2D.frame = 7
	elif left and right and down:
		$Sprite2D.frame = 10
	elif left and right and up:
		$Sprite2D.frame = 11
	elif left and right:
		$Sprite2D.frame = 4
	elif up and down:
		$Sprite2D.frame = 3
	elif right and down:
		$Sprite2D.frame = 5
	elif left and down:
		$Sprite2D.frame = 6
	elif right and up:
		$Sprite2D.frame = 8
	elif left and up:
		$Sprite2D.frame = 9
	elif left or right:
		$Sprite2D.frame = 4
	elif up or down:
		$Sprite2D.frame = 3

func update_roads():
	astargrid2d.update()

func is_road_tile(world_pos: Vector2) -> bool:
	for id in astargrid2d.get_points():
		var grid_pos = astargrid2d.get_point_position(id)
		if grid_pos == world_pos:
			return id in road_positions
	return false

func update_connections():
	left = road_positions.has(position + Vector2(-32, 0))
	right = road_positions.has(position + Vector2(32, 0))
	up = road_positions.has(position + Vector2(0, -32))
	down = road_positions.has(position + Vector2(0, 32))
