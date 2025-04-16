class_name BiomassLandfill
extends StorageBuilding
## A class that is for the aspects of a biomass landfill.
##
## A class that is for the aspects of a biomass landfill. This class extends from
## the StorageBuilding class.
##

var auto_expand_capacity_amount: int = 100
var amount_of_expansions: int = 0
var connected_landfill_sprites: Array[Sprite2D] = []
var connected_landfill_clickables: Array[TextureButton] = []
var grid_size: int = 32

signal landfill_expanded(landfill: BiomassLandfill, positon_expanded_to: Vector2)
signal landfill_shrinked(position_to_deocuppy: Vector2)

@onready var clickable: TextureButton = $Clickable

func  _process(delta: float) -> void:
	expand_landfill()
	shrink_landfill()

## Expand the landfill when at capacity
func expand_landfill() -> void:
	var current_biomass: int = output_storage.get(Enums.ResourceType.BIOMASS)
	var current_max_biomass: int = max_storage.get(Enums.ResourceType.BIOMASS)
	if current_biomass >= current_max_biomass:
		amount_of_expansions += 1
		
		max_storage.set(Enums.ResourceType.BIOMASS, current_max_biomass + auto_expand_capacity_amount)
		ResourceSignals.add_input_building.emit(self)
		
		var position_to_expand_to: Vector2 =  next_position_to_expand_to()
		
		var new_sprite: Sprite2D = building_sprite.duplicate()
		new_sprite.position += position_to_expand_to
		add_child(new_sprite)
		connected_landfill_sprites.append(new_sprite)
		
		var new_collision_shape: CollisionShape2D = null
		
		var building_info_button: TextureButton = clickable.duplicate()
		building_info_button.position += Vector2(position_to_expand_to)
		add_child(building_info_button)
		connected_landfill_clickables.append(building_info_button)
		
		landfill_expanded.emit(self, position_to_expand_to)

## Get the next position that the landfill can expand to
func next_position_to_expand_to() -> Vector2:
		var position_to_expand_to: Vector2 =  Vector2(grid_size, 0) * amount_of_expansions
		return position_to_expand_to
		
## Shrink the landfill below a threshold
func shrink_landfill() -> void:
	var current_biomass: int = output_storage.get(Enums.ResourceType.BIOMASS)
	var current_max_biomass: int = max_storage.get(Enums.ResourceType.BIOMASS)

	if (current_biomass < (current_max_biomass - auto_expand_capacity_amount)) and connected_landfill_sprites.size() > 0:
		amount_of_expansions -= 1
		var landfill_sprite: Sprite2D = connected_landfill_sprites.pop_back()
		landfill_shrinked.emit(position + landfill_sprite.position)
		landfill_sprite.queue_free()
		
		var landfill_clickable: TextureButton = connected_landfill_clickables.pop_back()
		landfill_clickable.queue_free()
		
		max_storage.set(Enums.ResourceType.BIOMASS, current_max_biomass - auto_expand_capacity_amount)
		ResourceSignals.add_input_building.emit(self)
