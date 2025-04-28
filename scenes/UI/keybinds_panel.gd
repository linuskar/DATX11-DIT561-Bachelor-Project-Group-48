extends UIMenu

func _ready() -> void:
	super()
	GameStateManager.show_keybinds.connect(update)

func update(show: bool) -> void:
	if show:
		self.show()
	else:
		self.hide()
