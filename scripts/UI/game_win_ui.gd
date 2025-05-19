extends UIMenu
@onready var exit_button: Button = $ExitButton

func _ready() -> void:
	super()
	exit_button.pressed.connect(_on_exit_button_pressed)

func _on_exit_button_pressed() -> void:
	get_tree().quit()

func hide_ui_menu() -> void:
	pass
