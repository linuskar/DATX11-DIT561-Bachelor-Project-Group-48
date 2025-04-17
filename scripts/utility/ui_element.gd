class_name UIElement extends Control

signal self_entered(element: PackedScene)
signal self_exited(element: PackedScene)

func _ready() -> void:
	mouse_entered.connect(_on_self_entered)
	mouse_exited.connect(_on_self_exited)

func _on_self_entered() -> void:
	self_entered.emit(self)

func _on_self_exited() -> void:
	self_exited.emit(self)
