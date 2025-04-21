extends ParallaxBackground

## get viewport size
## width 
## height
@onready var parallax_layer: ParallaxLayer = $ParallaxLayer
@onready var color_rect: ColorRect = $ParallaxLayer/ColorRect
const FOG = preload("res://assets/shaders/fog.gdshader")
var mat: ShaderMaterial
var noise_tex: NoiseTexture2D
@onready var camera_movement: CameraMovement
var width = 33280
var height = 33280

func _ready() -> void:
	var camera: Node = get_tree().get_first_node_in_group("camera")
	camera_movement = camera
	mat = color_rect.material
	noise_tex = mat.get_shader_parameter("noise_texture")

func _process(delta: float) -> void:
	#get_viewport_rect().size -canvas.origin / canvas.get_scale()
	#camera_movement.get_viewport_rect().size
	var viewport = camera_movement.get_viewport_rect().size
	#if noise_tex == null:
	#	print("null")
	# var shader_mat := $ColorRect.material as ShaderMaterial
	#mat.set_shader_parameter("camera_zoom", camera_movement.zoom.x) # assuming uniform zoom
	#mat.set_shader_parameter("camera_offset", camera_movement.global_position)
	
	#noise_tex.width = viewport.x
	#noise_tex.height = viewport.y
	#noise_tex.upd
	#var zoom: float = camera_movement.zoomTarget.y
	
	color_rect.size = viewport
	parallax_layer.motion_mirroring = viewport
	#mat.set_shader_parameter("zoom_factor", zoom)
	#noise_tex.
	#viewport /= viewport.get_scale()
	#var canvas: Transform2D = get_canvas_transform()
