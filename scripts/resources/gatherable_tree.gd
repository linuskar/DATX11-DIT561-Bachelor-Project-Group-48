class_name GatherableTree
extends GatherableResource
## A class representing a gatherable tree.
##
## A class representing a gatherable tree that can absorb emissions. This class
## extends the GatherableResource class.
##
##

## Dictionary for the maximum capacity of emissions that can be stored.
## Set the max capacity to -1 to indicate it has unlmited max capacity
## for a resource.
@export var emission_max_capacity: int
## The current storage of emissions.
var emission_storage: Dictionary[Enums.ResourceType, float] = {}

@onready var sprite_2d: Sprite2D = $Sprite2D

## Sprite that gets shown when resource is gathered
@onready var gathering_sprite_2d: Sprite2D = $GatheringSprite2D

var slightly_polluted_tree_sprite: CompressedTexture2D = preload("res://assets/trees/slightly_polluted_tree.png")
var heavily_polluted_tree_sprite: CompressedTexture2D = preload("res://assets/trees/heavily_polluted_tree.png")
var dead_tree_sprite: CompressedTexture2D = preload("res://assets/trees/dead_tree.png")

var polluted_level: Enums.PollutionLevel = Enums.PollutionLevel.NORMAL

var pollution_level_max_limits: Dictionary[Enums.PollutionLevel, int] = {}
var pollution_level_min_limits: Dictionary[Enums.PollutionLevel, int] = {}

var normal_range: Array 
var slightly_range: Array
var heavily_range: Array

func _ready() -> void:	
	emission_storage.set(Enums.ResourceType.CO2, 0)
	emission_storage.set(Enums.ResourceType.S02, 0)

	var min_level_value: int = 0
	var pollution_levels: Array[Enums.PollutionLevel] = Enums.pollution_level_ordering
	#pollution_levels.reverse()
	var i: int = pollution_levels.size()

	for pollution in pollution_levels:
		if pollution == Enums.PollutionLevel.DEAD:
			i -= 1
			continue
			
		var max_level_value: int = min(round(emission_max_capacity / i), emission_max_capacity)
		pollution_level_max_limits.set(pollution, max_level_value)
		pollution_level_min_limits.set(pollution, min_level_value)
		min_level_value = max_level_value
		
		i -= 1
	
	normal_range = range(pollution_level_min_limits.get(Enums.PollutionLevel.NORMAL), pollution_level_max_limits.get(Enums.PollutionLevel.NORMAL))
	slightly_range = range(pollution_level_min_limits.get(Enums.PollutionLevel.SLIGHTLY), pollution_level_max_limits.get(Enums.PollutionLevel.SLIGHTLY))
	heavily_range = range(pollution_level_min_limits.get(Enums.PollutionLevel.HEAVILY), pollution_level_max_limits.get(Enums.PollutionLevel.HEAVILY))

func _process(delta: float) -> void:
	update_pollution_level()
	
func update_pollution_level() -> void:
	var emission_stored: float = 0.0
	
	for emission_type in emission_storage.keys():
		if Enums.is_a_tree_pollution_contributor(emission_type):
			emission_stored += emission_storage.get(emission_type)
			
	if float(normal_range[0]) < emission_stored and emission_stored <= float(normal_range[-1]):
		polluted_level = Enums.PollutionLevel.NORMAL
	elif float(slightly_range[0]) < emission_stored and emission_stored <= float(slightly_range[-1]):
		polluted_level = Enums.PollutionLevel.SLIGHTLY
	elif float(heavily_range[0]) < emission_stored and emission_stored <= float(heavily_range[-1]):
		polluted_level = Enums.PollutionLevel.HEAVILY
	elif emission_stored > float(heavily_range[-1]):
		polluted_level = Enums.PollutionLevel.DEAD
		# TODO: make byproduct not return when quantity = 0
		quantity = 0

	update_pollution_level_visual()

func update_pollution_level_visual() -> void:
	match polluted_level:
		Enums.PollutionLevel.NORMAL:
			modulate = Color(1, 1, 1)
		Enums.PollutionLevel.SLIGHTLY:
			sprite_2d.region_enabled = false
			sprite_2d.texture = slightly_polluted_tree_sprite
		Enums.PollutionLevel.HEAVILY:
			sprite_2d.region_enabled = false
			sprite_2d.texture = heavily_polluted_tree_sprite
		Enums.PollutionLevel.DEAD:
			sprite_2d.region_enabled = false
			sprite_2d.texture = dead_tree_sprite

## Function to absorb emissions.
func absorb_emission(emission_type: Enums.ResourceType, amount: float):
	var amount_to_set: float = amount + emission_storage.get(emission_type)
	emission_storage.set(emission_type, amount_to_set)
