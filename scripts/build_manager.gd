class_name BuildManager
extends Node

@export var blueprint: Building
@export var grid_size: int = 32

@onready var world_layer: TileMapLayer = $"../WorldLayer"

var occupied_tiles: Dictionary = {}

var valid_placement_color: Color = Color(0.5, 0.5, 1, 0.8) 
var invalid_placement_color: Color = Color(1, 0.5, 0.5, 0.8)
var default_color: Color = Color(1, 1, 1, 1)

var buildings: Dictionary = {
	"factory": preload("res://scenes/factory.tscn"),
}

var buildings_placed: Array[Building]

var in_build_mode: bool = false
var valid_placement: bool = false

signal placed_building

func _ready() -> void:
	GameManager.build_mode.connect(_on_build_mode)
	
func _process(_delta) -> void:
	match GameManager.state:
		GameManager.State.PLACE_BUILDING:
			var mouse_pos: Vector2 = get_parent().get_local_mouse_position()
			var tile_pos: Vector2 = world_layer.local_to_map(mouse_pos)
			var world_pos: Vector2 = world_layer.map_to_local(tile_pos)
			
			blueprint.position = world_pos 
			
			if is_tile_occupied(world_pos):
				print("occupied")
				blueprint.modulate = invalid_placement_color
				valid_placement = false
			else:
				print("fine")
				blueprint.modulate = valid_placement_color	
				valid_placement = true
				
			if Input.is_action_pressed("place") and valid_placement:
				place_building()
				
		GameManager.State.IDLE:
			pass
		
		
func _on_build_mode() -> void:
	match GameManager.state:
		GameManager.State.IDLE:
			blueprint.hide()  
			blueprint.modulate = default_color
			
		GameManager.State.PLACE_BUILDING:
			blueprint.show()
			blueprint.modulate = valid_placement_color
		
		
func place_building() -> void:
	var new_building: Building = buildings.get("factory").instantiate()
	new_building.position = blueprint.position
	buildings_placed.append(new_building)
	get_parent().add_child(new_building)
	_on_placed_building(new_building)
	
func is_tile_occupied(position: Vector2) -> bool:
	return occupied_tiles.has(position)

func _on_placed_building(building: Building) -> void:
	occupied_tiles[building.position] = building
	#print(occupied_tiles.size())
