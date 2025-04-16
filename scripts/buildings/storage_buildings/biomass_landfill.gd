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

signal landfill_expanded(landfill: BiomassLandfill, positon_expanded_to: Vector2)
signal landfill_shrinked(landfill: BiomassLandfill, positon_expanded_to: Vector2)

@onready var clickable: TextureButton = $Clickable

func  _process(delta: float) -> void:
	expand_landfill()
	shrink_landfill()

## Expansion function
func expand_landfill() -> void:
	## TODO intsantiate a new landfill, or occupy another tile with another sprite
	## of the same instance
	var current_biomass: int = output_storage.get(Enums.ResourceType.BIOMASS)
	var current_max_biomass: int = max_storage.get(Enums.ResourceType.BIOMASS)
	if current_biomass >= current_max_biomass:
		amount_of_expansions += 1
		max_storage.set(Enums.ResourceType.BIOMASS, current_max_biomass + auto_expand_capacity_amount)
		ResourceSignals.add_input_building.emit(self)
		var grid_size: int = 32
		## moves right
		var position_to_expand_to: Vector2 =  Vector2(grid_size, 0) * amount_of_expansions
		landfill_expanded.emit(self, position_to_expand_to)
		
func shrink_landfill() -> void:
	var current_biomass: int = output_storage.get(Enums.ResourceType.BIOMASS)
	var current_max_biomass: int = max_storage.get(Enums.ResourceType.BIOMASS)

	if (current_biomass < (current_max_biomass - auto_expand_capacity_amount)) and connected_landfill_sprites.size() > 0:
		var landfill_sprite: Sprite2D = connected_landfill_sprites.pop_back()
		landfill_shrinked.emit(self, position + landfill_sprite.position)
		landfill_sprite.queue_free()
		
		var landfill_clickable: TextureButton = connected_landfill_clickables.pop_back()
		landfill_clickable.queue_free()
		
		max_storage.set(Enums.ResourceType.BIOMASS, current_max_biomass - auto_expand_capacity_amount)
		ResourceSignals.add_input_building.emit(self)
