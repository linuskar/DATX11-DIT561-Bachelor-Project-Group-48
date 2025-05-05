class_name GatherableTree
extends GatherableResource
## A class representing a gatherable tree.
##
## A class representing a gatherable tree that can absorb emissions. This class
## extends the GatherableResource class.
##
##

## The maximum amount of pollution a tree can absorb before it is considered dead
@export var max_pollution_capacity: float
@onready var sprite_2d: Sprite2D = $Sprite2D
## Sprite that gets shown when resource is gathered
@onready var gathering_sprite_2d: Sprite2D = $GatheringSprite2D
@onready var wildfire: WildFire = $Wildfire

var burn_state: Enums.BurnState = Enums.BurnState.NORMAL
var burn_time: float = 3.0 
var spread_radius: int = 32
var fire_spread_probability: float = 0.0

## The current storage of emissions.
var emission_storage: Dictionary[Enums.ResourceType, float] = {}

var polluted_level: Enums.PollutionLevel = Enums.PollutionLevel.NORMAL

## Dictionary containing the maximum value limits for pollution levels
var pollution_level_max_limits: Dictionary[Enums.PollutionLevel, float] = {}
## Dictionary containing the minimum value limits for pollution levels
var pollution_level_min_limits: Dictionary[Enums.PollutionLevel, float] = {}

var tree_sprites: Dictionary[Enums.TreeSize, CompressedTexture2D]

var tree_size: Enums.TreeSize

const grid_size: float = 32.0
const normal_tree_sprite_x: float = grid_size * 0
const slightly_polluted_tree_sprite_x: float = grid_size * 1
const heavily_polluted_tree_sprite_x: float = grid_size * 2
const dead_tree_sprite_x: float = grid_size * 3

func _ready() -> void:
	for emission in Enums.emissions:
		emission_storage.set(emission, 0)
	wildfire.stop_fire()
	sprite_2d.material.set_shader_parameter("world_matrix", global_transform)
	init_tree_size()
	init_pollution_level_limits()

## Function to initialize the tree size
func init_tree_size() -> void:
	var random_int = randi_range(0, Enums.TreeSize.size() - 1)
	
	tree_size = Enums.TreeSize.values()[random_int]

	sprite_2d.region_rect.position.y = grid_size * tree_size
	quantity *= Enums.tree_size_multiplier_quantity.get(tree_size)

## Function to initialize the value limits for the pollution levels to a tree
func init_pollution_level_limits() -> void:
	var min_level_value: float = 0
	var i: int = Enums.PollutionLevel.size()

	for level in Enums.PollutionLevel.values():
		if level == Enums.PollutionLevel.DEAD:
			i -= 1
			continue
			
		var max_level_value: float = min(max_pollution_capacity / i, max_pollution_capacity) * Enums.tree_size_multiplier_pollution.get(tree_size)
		pollution_level_max_limits.set(level, max_level_value)
		pollution_level_min_limits.set(level, min_level_value)
		min_level_value = max_level_value
		
		i -= 1

## Function to absorb emissions.
func absorb_emission(emission_type: Enums.ResourceType, amount: float):
	if polluted_level != Enums.PollutionLevel.DEAD or burn_state != Enums.BurnState.DEAD:
		var amount_to_set: float = amount + emission_storage.get(emission_type)
		emission_storage.set(emission_type, amount_to_set)
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
		quantity = 0
		TreeSignals.dead.emit(self)

	update_pollution_level_visual()
	
## Function update the visuals of a tree based on pollution level
func update_pollution_level_visual() -> void:
	match polluted_level:
		Enums.PollutionLevel.NORMAL:
			sprite_2d.region_rect.position.x = normal_tree_sprite_x
		Enums.PollutionLevel.SLIGHTLY:
			sprite_2d.region_rect.position.x = slightly_polluted_tree_sprite_x
		Enums.PollutionLevel.HEAVILY:
			sprite_2d.region_rect.position.x = heavily_polluted_tree_sprite_x
		Enums.PollutionLevel.DEAD:
			burn_state = Enums.BurnState.DEAD
			sprite_2d.region_rect.position.x = dead_tree_sprite_x

## Function to ignite the tree on fire
func start_burning(fire_prob: float) -> void:
	if burn_state != Enums.BurnState.NORMAL or polluted_level == Enums.PollutionLevel.DEAD:
		return
	fire_spread_probability = fire_prob
	burn_state = Enums.BurnState.BURNING
	update_burn_visual()
	become_burnt()
	
## Function to update the burn visuals of a tree
func update_burn_visual():
	match burn_state:
		Enums.BurnState.NORMAL:
			sprite_2d.region_rect.position.x = normal_tree_sprite_x
		Enums.BurnState.BURNING:
			wildfire.start_fire()
		Enums.BurnState.DEAD:
			polluted_level = Enums.PollutionLevel.DEAD
			wildfire.stop_fire()
			sprite_2d.region_rect.position.x = dead_tree_sprite_x

## Function to make the tree burnt and spread the fire 
func become_burnt() -> void:
	## Wait for a certain amount of time, spread the fire and then become burnt
	await get_tree().create_timer(burn_time).timeout
	spread_fire()

	burn_state = Enums.BurnState.DEAD
	update_burn_visual()
	quantity = 0
	TreeSignals.dead.emit(self)
	
## Function to spread the fire to nearby trees in range
func spread_fire():
	var nearby_trees: Array[Node] = get_tree().get_nodes_in_group("trees")
	for tree in nearby_trees:
		## Don't spread fire to itself
		if tree == self:
			continue
		## Tree in range
		if position.distance_to(tree.position) <= spread_radius:
			## Start burning trees that have not been burned before,
			## based on a probability for a fire to start
			if tree.burn_state == Enums.BurnState.NORMAL and randf() <= fire_spread_probability:
				tree.start_burning(fire_spread_probability)
