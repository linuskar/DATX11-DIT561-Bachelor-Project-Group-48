extends Sprite2D

var total_frames = 64
var movement_speed = 100.0 * 10
static var astargrid2d = ResourceSignals.astargrid2d

var path = []
var path_index = 0

func _ready() -> void:
	ResourceSignals.update_truck_path.connect(move_to_position)

func _process(delta):
	move_along_path(delta)

func move_to_position(next_pos: Vector2):
	var start_grid = world_to_grid(position)
	var end_grid = world_to_grid(next_pos)
	
	if not astargrid2d.is_in_boundsv(start_grid) or not astargrid2d.is_in_boundsv(end_grid):
		print("Error: Start or end position is out of bounds!")
		return
	
	if not is_road_tile(end_grid):
		print("Error: Target position is not a road!")
		return
	
	path = astargrid2d.get_point_path(start_grid, end_grid)
	path_index = 0

func is_road_tile(grid_pos: Vector2i) -> bool:
	var world_pos = grid_pos * astargrid2d.cell_size
	return ResourceSignals.road_positions.has(world_pos)

func world_to_grid(world_pos: Vector2) -> Vector2i:
	return ((world_pos - astargrid2d.region.position) / astargrid2d.cell_size).floor()
	
func move_along_path(delta):
	if path_index < path.size():
		var target_pos = path[path_index]
		var direction = (target_pos - position).normalized()
		position += direction * movement_speed * delta

		var angle = direction.angle() + PI / 2
		var frame = int((angle / (2 * PI)) * total_frames) % total_frames
		self.frame = clamp(frame, 0, total_frames - 1)

		if position.distance_to(target_pos) < 5:
			path_index += 1

	if path_index >= path.size():
		path = []
