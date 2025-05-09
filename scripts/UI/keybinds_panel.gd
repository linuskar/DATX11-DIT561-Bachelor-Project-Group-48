extends UIMenu

func _ready() -> void:
	GameStateManager.show_keybinds.connect(update)

func update(show: bool) -> void:
	if show:
		self.show()
	else:
		self.hide()

func _on_tutorial_show() -> void:
	GameStateManager.tutorial_visibility_changed.emit(true)
	GameStateManager.tutorial_visibility_changed.connect(_on_tutorial_closed)
	hide_ui_menu()

func _on_tutorial_closed(tutorial_visible: bool) -> void:
	if not tutorial_visible:
		GameStateManager.tutorial_visibility_changed.disconnect(_on_tutorial_closed)
