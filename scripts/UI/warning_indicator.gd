class_name WarningIndicator
extends Node2D

@onready var marker: Sprite2D = $Marker
@onready var warning_icon: Sprite2D = $Marker/WarningIcon

var target_pos = null

func _process(delta: float) -> void:
	var canvas: Transform2D = get_canvas_transform()
	var top_left: Vector2 = -canvas.origin / canvas.get_scale()
	var size: Vector2 = get_viewport_rect().size / canvas.get_scale()
	
	set_indicator_positon(Rect2(top_left, size))
	set_indicator_rotation()
	
## Function to set the position of the indicator
func set_indicator_positon(bounds: Rect2):
	if target_pos == null:
		## TODO: adjust for TOP UI, to avoid +80 offest
		marker.global_position.x = clamp(global_position.x, bounds.position.x, bounds.end.x)
		marker.global_position.y = clamp(global_position.y, bounds.position.y+80, bounds.end.y)
	## TODO, future implementation currently implementation with target_pos does not work properly,
	## followed this guide: https://www.youtube.com/watch?v=Sw9Iiejkae4 
	else:
		var displacement: Vector2 = global_position - target_pos
		var length: float
		
		var tl: float = (bounds.position - target_pos).angle()
		var tr: float = (Vector2(bounds.end.x, bounds.position.y) - target_pos).angle()
		var bl: float = (Vector2(bounds.position.x, bounds.end.y) - target_pos).angle()
		var br: float = (bounds.end - target_pos).angle()
		
		if (displacement.angle() > tl and displacement.angle() < tr) || (displacement.angle() < bl and displacement.angle() > br):
			var y_length: float = clamp(displacement.y, bounds.position.y - target_pos.y, bounds.end.y - target_pos.y)
			var angle: float = displacement.angle() - PI / 2.0
			length = y_length / cos(angle) if cos(angle) != 0 else y_length
		else:
			var x_length: float = clamp(displacement.x, bounds.position.x - target_pos.x, bounds.end.x - target_pos.x)
			var angle: float = displacement.angle()
			length = x_length / cos(angle) if cos(angle) != 0 else x_length
		
		marker.global_position = Vector2(length, 0).rotated(displacement.angle()) + target_pos

	if bounds.has_point(global_position):
		hide()
	else:
		show()

## Function to set the rotation of the indicator
func set_indicator_rotation():
	var angle: float = (global_position - marker.global_position).angle()
	marker.global_rotation = angle
	warning_icon.global_rotation = 0
