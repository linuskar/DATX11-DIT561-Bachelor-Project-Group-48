extends Sprite2D

var total_frames = 64
var movement_speed = 100.0 * 10
static var astargrid2d = ResourceSignals.astargrid2d

var path = []
var path_index = 0

func _ready() -> void:
	pass

func _process(delta):
	pass

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
