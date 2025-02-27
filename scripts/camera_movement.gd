extends Camera2D

@export var zoomSpeed :float = 10;
 
var zoomTarget :Vector2

var simplePanSpeed = 4
var maxZoom = 3.6
var minZoom = 0.7

var maxZoomLength = Vector2(maxZoom, maxZoom).length()
var minZoomLength = Vector2(minZoom, minZoom).length()

var dragStartMousePos = Vector2.ZERO
var dragStartCameraPos = Vector2.ZERO
var isDragging : bool = false

func _ready():
	zoomTarget = zoom

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	Zoom(delta)
	SimplePan()
	ClickAndDrag()

func Zoom(delta):
	if Input.is_action_just_pressed("camera_zoom_in"):
		if (zoomTarget * 1.1).length() < maxZoomLength:
			zoomTarget *= 1.1
		else:
			zoomTarget = Vector2(maxZoom, maxZoom)
		print(zoomTarget)
	
	if Input.is_action_just_pressed("camera_zoom_out"):
		if (zoomTarget * 0.9).length() > minZoomLength:
			zoomTarget *= 0.9
		else:
			zoomTarget = Vector2(minZoom, minZoom)
	
	zoom = zoom.slerp(zoomTarget, zoomSpeed * delta)

func SimplePan():
	if Input.is_action_pressed("camera_move_right"):
		position.x += simplePanSpeed
	
	if Input.is_action_pressed("camera_move_left"):
		position.x -= simplePanSpeed
	
	if Input.is_action_pressed("camera_move_up"):
		position.y -= simplePanSpeed
	
	if Input.is_action_pressed("camera_move_down"):
		position.y += simplePanSpeed

func ClickAndDrag():
	if !isDragging and Input.is_action_just_pressed("camera_pan"):
		dragStartMousePos = get_viewport().get_mouse_position()
		dragStartCameraPos = position
		isDragging = true
	
	if isDragging and Input.is_action_just_released("camera_pan"):
		isDragging = false
	
	if isDragging:
		var moveVector = get_viewport().get_mouse_position() - dragStartMousePos
		position = dragStartCameraPos - moveVector * 1/zoom.x
