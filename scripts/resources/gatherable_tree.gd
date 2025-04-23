class_name GatherableTree
extends GatherableResource
## A class representing a gatherable tree.
##
## A class representing a gatherable tree that can absorb emissions. This class
## extends the GatherableResource class.
##
##

## The maximum amount of pollution a tree can absorb before it is considered dead
@export var max_pollution_max_capacity: float

@onready var sprite_2d: Sprite2D = $Sprite2D

## Sprite that gets shown when resource is gathered
@onready var gathering_sprite_2d: Sprite2D = $GatheringSprite2D

## The current storage of emissions.
var emission_storage: Dictionary[Enums.ResourceType, float] = {}

var slightly_polluted_tree_sprite: CompressedTexture2D = preload("res://assets/trees/slightly_polluted_tree.png")
var heavily_polluted_tree_sprite: CompressedTexture2D = preload("res://assets/trees/heavily_polluted_tree.png")
var dead_tree_sprite: CompressedTexture2D = preload("res://assets/trees/dead_tree.png")

var polluted_level: Enums.PollutionLevel = Enums.PollutionLevel.NORMAL

## Dictionary containing the maximum value limits for pollution levels
var pollution_level_max_limits: Dictionary[Enums.PollutionLevel, float] = {}
## Dictionary containing the minimum value limits for pollution levels
var pollution_level_min_limits: Dictionary[Enums.PollutionLevel, float] = {}

func _ready() -> void:	
	emission_storage.set(Enums.ResourceType.CO2, 0)
	emission_storage.set(Enums.ResourceType.S02, 0)

	init_pollution_level_limits()

## Function to initialize the value limits for the pollution levels to a tree
func init_pollution_level_limits() -> void:
	var min_level_value: float = 0
	var i: int = Enums.PollutionLevel.size()

	for level in Enums.PollutionLevel.values():
		if level == Enums.PollutionLevel.DEAD:
			i -= 1
			continue
			
		var max_level_value: float = min(max_pollution_max_capacity / i, max_pollution_max_capacity)
		pollution_level_max_limits.set(level, max_level_value)
		pollution_level_min_limits.set(level, min_level_value)
		min_level_value = max_level_value
		
		i -= 1
		
func _process(delta: float) -> void:
	update_pollution_level()

## Function to update the pollution level of a tree 
## based on contributing emissions
func update_pollution_level() -> void:
	var emission_stored: float = 0.0
	
	for emission_type in emission_storage.keys():
		if Enums.is_a_tree_pollution_contributor(emission_type):
			emission_stored += emission_storage.get(emission_type)
			
	var min_normal: float = pollution_level_min_limits.get(Enums.PollutionLevel.NORMAL)
	var max_normal: float = pollution_level_max_limits.get(Enums.PollutionLevel.NORMAL)
	
	var min_slightly: float = pollution_level_min_limits.get(Enums.PollutionLevel.SLIGHTLY)
	var max_slightly: float = pollution_level_max_limits.get(Enums.PollutionLevel.SLIGHTLY)
	
	var min_heavily: float = pollution_level_min_limits.get(Enums.PollutionLevel.HEAVILY)
	var max_heavily: float = pollution_level_max_limits.get(Enums.PollutionLevel.HEAVILY)
	
	if min_normal < emission_stored and emission_stored <= max_normal:
		polluted_level = Enums.PollutionLevel.NORMAL
	elif min_slightly < emission_stored and emission_stored <= max_slightly:
		polluted_level = Enums.PollutionLevel.SLIGHTLY
	elif min_heavily < emission_stored and emission_stored <= max_heavily:
		polluted_level = Enums.PollutionLevel.HEAVILY
	elif emission_stored > max_heavily:
		polluted_level = Enums.PollutionLevel.DEAD
		# TODO: make byproduct not return when quantity = 0
		quantity = 0

	update_pollution_level_visual()
	
## Function update the visuals of a tree based on pollution level
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
