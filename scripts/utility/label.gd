extends Label

## Boolean keeping track of whether the label is hovered over or not
var hovering: bool

## Handling signal for pressing the left mouse button
func _input(event: InputEvent) -> void:
	if event is InputEventMouseButton and event.is_pressed() and event.button_index == MOUSE_BUTTON_LEFT:
		if hovering:
			StateManager.set_state(StateManager.State.PLACE_BUILDING)
			StateManager.build_mode.emit()


func _on_mouse_entered() -> void:
	hovering = true


func _on_mouse_exited() -> void:
	hovering = false
