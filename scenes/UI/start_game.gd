extends Button

func start_game() -> void:
	get_tree().paused = false
	self.get_parent_control().get_parent().hide()
