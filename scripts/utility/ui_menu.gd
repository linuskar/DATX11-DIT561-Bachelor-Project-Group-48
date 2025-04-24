class_name UIMenu extends UIElement

func _ready() -> void:
	super()
	visibility_changed.connect(_on_menu_visibility_changed)

func _on_menu_visibility_changed() -> void:
	if self.visible:
		GameStateManager.add_menu(self)
	else:
		GameStateManager.remove_menu(self)
