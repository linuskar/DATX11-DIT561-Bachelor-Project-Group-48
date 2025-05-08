extends Node

## Signal that is emitted or received when the state
## of the game updates.
signal game_state_updated(paused: bool)

## Signal emitted when the game begins or ends
signal game_started(running: bool)

## Signal emitted when keybinds panel is to be shown
## or hidden
signal show_keybinds(show: bool)

## Signal emitted when the tutorial panel
signal tutorial_visibility_changed(opened: bool)

## A dictionary of all currently opened menus
var opened_menus: Array[UIMenu] = []

## Signal emitted when the grid setting is toggled
signal grid_setting_toggled(toggled_on: bool)

## Set the script to always update even if the rest of 
## the game is paused.
func _ready() -> void:
	process_mode = Node.PROCESS_MODE_ALWAYS
	game_state_updated.connect(update_game_state)

## If the 'pause game' button is pressed halt all processes
## default button is tab
func _input(event: InputEvent) -> void:
	if Input.is_action_just_pressed("pause game"):
		if not opened_menus.is_empty():
			var current_menu: UIMenu = opened_menus.pop_back()
			current_menu.hide_ui_menu()
		else:
			game_state_updated.emit(not get_tree().paused)

## Updates the state of the game to the given variable
func update_game_state(paused: bool) -> void:
	get_tree().paused = paused

## Unpauses the game
func _resume_game() -> void:
	game_state_updated.emit(false)
	get_tree().paused = false

func add_menu(menu: UIMenu) -> void:
	opened_menus.append(menu)

func remove_menu(menu: UIMenu) -> void:
	opened_menus.erase(menu)
