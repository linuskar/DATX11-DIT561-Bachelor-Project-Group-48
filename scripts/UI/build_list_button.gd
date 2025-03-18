extends TextureButton

## Color that is shown when button is hovered over
var hovered_color: Color = Color(0.1, 0.1, 0.1, 0.25)

## Color that is shown when button is not being hovered over
var regular_color: Color = Color(0.1, 0.1, 0.1, 0)

## Sets the color to hovered
func _on_mouse_entered() -> void:
	self.modulate = hovered_color

## Sets the color to regular
func _on_mouse_exited() -> void:
	self.modulate = regular_color
