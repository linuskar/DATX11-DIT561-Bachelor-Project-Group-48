class_name TutorialScreen extends UIMenu

func _ready() -> void:
	super()
	GameStateManager.tutorial_visibility_changed.connect(change_visibility)

func _on_ready() -> void:
	show()

func change_visibility(visible: bool) -> void:
	if visible:
		show()
	else:
		hide()

func hide_ui_menu() -> void:
	super()
	GameStateManager.tutorial_visibility_changed.emit(visible)
