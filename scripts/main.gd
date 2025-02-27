extends Node

@onready var control: Control = $Control
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass

	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass

func _input(event) -> void:
	if event.is_action_pressed("build"):
		
		match GameManager.state:
			
			GameManager.State.IDLE:
				GameManager.set_state(GameManager.State.PLACE_BUILDING)
				
			GameManager.State.PLACE_BUILDING:
				GameManager.set_state(GameManager.State.IDLE)
				
		GameManager.build_mode.emit()
	
	if event.is_action_pressed("i"):
		control.visible = !control.visible
