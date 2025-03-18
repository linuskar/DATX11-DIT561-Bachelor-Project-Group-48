extends TextureButton

var hovered_color: Color = Color(0.1, 0.1, 0.1, 0.25)
var regular_color: Color = Color(0.1, 0.1, 0.1, 0)

func _on_mouse_entered() -> void:
	self.modulate = hovered_color


func _on_mouse_exited() -> void:
	self.modulate = regular_color
