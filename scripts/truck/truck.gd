extends Sprite2D

# Total frames in the sprite sheet (64 for 360 degrees)
var total_frames = 64
# Rotation speed in radians per second (adjust as needed)
var rotation_speed = 5
# Current rotation angle
var current_angle = 0.0
# Movement speed in pixels per second
var movement_speed = 100.0 * 10

func _process(delta):
	# Handle rotation input
	if Input.is_action_pressed("camera_move_right"):
		current_angle += rotation_speed * delta
	elif Input.is_action_pressed("camera_move_left"):
		current_angle -= rotation_speed * delta
	
	# Wrap the angle to stay within 0–2π (0–360 degrees)
	current_angle = wrapf(current_angle, 0, 2 * PI)
	
	# Map the angle to the correct frame (0–63)
	var frame = int((current_angle / (2 * PI)) * total_frames) % total_frames
	# Ensure the frame is within bounds
	frame = clamp(frame, 0, total_frames - 1)
	
	# Set the current frame
	self.frame = frame
	
	# Calculate the direction vector with an offset of 90 degrees (PI/2 radians)
	var offset_angle = current_angle + PI / 2
	var direction = Vector2.ZERO
	if Input.is_action_pressed("camera_move_up"):  # W key for forward
		direction = Vector2(cos(offset_angle), sin(offset_angle))
	elif Input.is_action_pressed("camera_move_down"):  # S key for backward
		direction = Vector2(-cos(offset_angle), -sin(offset_angle))
	
	# Move the truck
	position += direction * movement_speed * delta
