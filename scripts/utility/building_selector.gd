extends Node2D

## Variable for whether the mouse is being dragged or not
var dragging: bool = false
## Start position for the selecting rectangle
var drag_start: Vector2 = Vector2.ZERO
## The selecting rectangle
var select_rect: RectangleShape2D = RectangleShape2D.new()
## Signal emitted containing the selected buildings
signal buildings_selected(buildings: Array[Building])

func _draw() -> void:
	if dragging:
		draw_rect(Rect2(drag_start, get_global_mouse_position() - drag_start)
		, Color(0.5, 0.5, 0.5, 0.5), true)

## Handling input for the box selection
func _unhandled_input(event: InputEvent) -> void:
	## Only do selection logic if the player is not currently placing a building
	if StateManager.state == StateManager.State.IDLE:
		## Selection is triggered by pressing the left mouse button
		if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT:
			## On press record starting position and set dragging to true
			if event.pressed:
				dragging = true
				drag_start = get_global_mouse_position()
			## If the button was just released, get the selected buildings 
			elif dragging:
				## Create empty list of buildings
				var selected: Array[Building] = []
				## Set dragging to false
				dragging = false
				## Redraw the rectangle one last time
				queue_redraw()
				## Get the end position for the rectangle
				var drag_end: Vector2 = get_global_mouse_position()
				## Set size of rectangle (set like radius)
				select_rect.extents = (drag_end - drag_start)/2
				## Gets the state of the 2D world 
				var space = get_world_2d().direct_space_state
				## An empty query to be used for the space
				var query = PhysicsShapeQueryParameters2D.new()
				## Setting the shape of the query
				query.shape = select_rect
				## Setting the (center) position 
				query.transform = Transform2D(0, (drag_end + drag_start)/2)
				## Querying the space for collisions
				var selected_dicts = space.intersect_shape(query)
				for dict in selected_dicts:
					selected.append(dict.get("collider"))
				buildings_selected.emit(selected)
			
	## If the event is mouse movement, update the rectangle
	if event is InputEventMouseMotion and dragging:
		queue_redraw()
