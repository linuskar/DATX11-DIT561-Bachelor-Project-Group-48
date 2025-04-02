extends Camera2D

@export var zoomSpeed :float = 10;
 
var zoomTarget :Vector2

var can_zoom: bool

#Decide how fast wasd pan speed is, higher nr is faster
@export var simplePanSpeed = 4

#Decide max and min zoom
#Bigger nr = more zoomed in
@export var maxZoom = 3.6
@export var minZoom = 0.7

var maxZoomLength = Vector2(maxZoom, maxZoom).length()
var minZoomLength = Vector2(minZoom, minZoom).length()

#Decide how sensitive the zoom is, bigger number is more sensitiv
@export var zoomSensitivity = 0.1

var dragStartMousePos = Vector2.ZERO
var dragStartCameraPos = Vector2.ZERO
var isDragging : bool = false

func _ready():
	zoomTarget = zoom
	ZoomHandler.allow_zoom.connect(set_can_zoom)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	Zoom(delta)
	SimplePan()
	ClickAndDrag()

#Code for zoom
func Zoom(delta):
	if can_zoom:
		if Input.is_action_just_pressed("camera_zoom_in"):
			if (zoomTarget * (1 + zoomSensitivity)).length() < maxZoomLength:
				zoomTarget *= 1 + zoomSensitivity
			else:
				zoomTarget = Vector2(maxZoom, maxZoom)
			print(zoomTarget)
		
		if Input.is_action_just_pressed("camera_zoom_out"):
			if (zoomTarget * (1 - zoomSensitivity)).length() > minZoomLength:
				zoomTarget *= 1 - zoomSensitivity
			else:
				zoomTarget = Vector2(minZoom, minZoom)
		
		zoom = zoom.slerp(zoomTarget, zoomSpeed * delta)

#Code for wasd movement
#Can change/add movment buttons in Project -> Project settings -> Input map
func SimplePan():
	if Input.is_action_pressed("camera_move_right"):
		position.x += simplePanSpeed
	
	if Input.is_action_pressed("camera_move_left"):
		position.x -= simplePanSpeed
	
	if Input.is_action_pressed("camera_move_up"):
		position.y -= simplePanSpeed
	
	if Input.is_action_pressed("camera_move_down"):
		position.y += simplePanSpeed

#Code for the click and drag movement
#Can change pan button in Project -> Project settings -> Input map
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

func set_can_zoom(zoom_allowed: bool) -> void:
	self.can_zoom = zoom_allowed
