extends Node2D

## Variable for whether the mouse is being dragged or not
var dragging: bool = false
## List of buildings that were selected
var selected: Array = []
## Start position for the selecting rectangle
var drag_start: Vector2 = Vector2.ZERO
## The selecting rectangle
var select_rect: RectangleShape2D = RectangleShape2D.new()

func _draw() -> void:
	if dragging:
		draw_rect(Rect2(drag_start, get_global_mouse_position() - drag_start)
		, Color(0.5, 0.5, 0.5, 0.5), true)

## Handling input for the box selection
func _unhandled_input(event: InputEvent) -> void:
	## Selection is triggered by pressing the left mouse button
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT:
		## On press record starting position and set dragging to true
		if event.pressed:
			dragging = true
			drag_start = get_global_mouse_position()

		## If the button was just released,
		elif dragging:
			selected = []
			dragging = false
			queue_redraw()
			var drag_end = get_global_mouse_position()
			select_rect.extents =(drag_end - drag_start)/2
			var space = get_world_2d().direct_space_state
			var query = PhysicsShapeQueryParameters2D.new()
			query.shape = select_rect
			query.transform = Transform2D(0, (drag_end + drag_start)/2)
			selected = space.intersect_shape(query)
			print(selected)
	if event is InputEventMouseMotion and dragging:
		queue_redraw()
