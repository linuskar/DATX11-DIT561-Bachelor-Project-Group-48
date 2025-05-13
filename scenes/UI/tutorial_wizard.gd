extends VBoxContainer

## The currently visible panel
var current_index = 0

## The number of tutorial panels.
var panel_count: int = 0

@onready var content: MarginContainer = $Content
@onready var forward_button: Button = $StepButtons/MarginContainer/ButtonBar/Forward
@onready var backward_button: Button = $StepButtons/MarginContainer/ButtonBar/Backward

func step_forward() -> void:
	backward_button.disabled = false
	if current_index < panel_count - 1:
		current_index += 1
		set_panel_active(current_index)
		if current_index == panel_count - 1:
			forward_button.disabled = true

func step_backward() -> void:
	forward_button.disabled = false
	if current_index > 0:
		current_index -= 1
		set_panel_active(current_index)
		if current_index == 0:
			backward_button.disabled = true

func set_panel_active(index: int) -> void:
	for child in content.get_children():
		child.hide()
	content.get_child(index).show()

func _on_ready() -> void:
	panel_count = content.get_children().size()
