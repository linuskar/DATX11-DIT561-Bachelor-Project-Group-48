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
var occupied_tiles_by_landfill: Array[Vector2] = []
var grid_size: int = 32
var position_to_expand_to: Vector2

signal landfill_expanded(landfill: BiomassLandfill, positon_expanded_to: Vector2)
signal landfill_shrinked(landfill: BiomassLandfill, position_to_deocuppy: Vector2)

@onready var clickable: TextureButton = $Clickable

func  _process(delta: float) -> void:
	expand_landfill()
	shrink_landfill()

## Expand the landfill when at capacity
func expand_landfill() -> void:
	var current_biomass: int = output_storage.get(Enums.ResourceType.BIOMASS)
	var current_max_biomass: int = max_storage.get(Enums.ResourceType.BIOMASS)
	if current_biomass >= current_max_biomass:
		next_position_to_expand_to(connected_landfill_sprites.size() - 1)

		## TODO: Why is there a problem here? It will otherwise not expand at all
		## even if there is space
		## If no possible positon that the landfill can expand to
		if position_to_expand_to.x == 0 and position_to_expand_to.y == 0 and connected_landfill_sprites.size() > 0:
			return
		
		amount_of_expansions += 1
		
		max_storage.set(Enums.ResourceType.BIOMASS, current_max_biomass + auto_expand_capacity_amount)
		ResourceSignals.add_input_building.emit(self)
	
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
func next_position_to_expand_to(index: int) -> void:
		var prev_landfill_pos: Vector2 = Vector2(0,0)
		
		## Go through all tiles the landfill occupies and eventually stop
		if index >= 0:
			prev_landfill_pos = connected_landfill_sprites[index].position

		position_to_expand_to = look_at_tiles_around(prev_landfill_pos)

		## if no direction was possible
		if position_to_expand_to.x == 0 and position_to_expand_to.y == 0:
			next_position_to_expand_to(index - 1)
	
func look_at_tiles_around(current_tile: Vector2) -> Vector2:
	var occupied_tiles: Array[Vector2] = BuildManagerGlobal.occupied_tiles.keys()
	var pos: Vector2 = Vector2(0,0)
	var directions = Enums.Direction.values()
	directions.shuffle()
	
	var valid_tile_types_to_place: Array[Enums.TileType] = building_data.valid_tile_types_to_place_on
	var source_id: int = -1
	
	## Have to check for occupied tiles
	## TODO: Check for tile type that the landfill can be placed on
	for direction in directions:
		match direction:
			Enums.Direction.UP:
				pos = Vector2(0, -grid_size) + current_tile
			Enums.Direction.DOWN:
				pos = Vector2(0, grid_size) + current_tile
			Enums.Direction.LEFT:
				pos = Vector2(-grid_size, 0) + current_tile
			Enums.Direction.RIGHT:
				pos = Vector2(grid_size, 0) + current_tile
		var position_to_check: Vector2 = pos + self.position
		## TODO: check valid tile here
		if !(position_to_check in occupied_tiles):
			return pos
		pos = Vector2(0,0)
	return pos
	
## Shrink the landfill below a threshold
func shrink_landfill() -> void:
	var current_biomass: int = output_storage.get(Enums.ResourceType.BIOMASS)
	var current_max_biomass: int = max_storage.get(Enums.ResourceType.BIOMASS)

	if (current_biomass < (current_max_biomass - auto_expand_capacity_amount)) and connected_landfill_sprites.size() > 0:
		amount_of_expansions -= 1
		var landfill_sprite: Sprite2D = connected_landfill_sprites.pop_back()
		landfill_shrinked.emit(self, position + landfill_sprite.position)
		landfill_sprite.queue_free()
		
		var landfill_clickable: TextureButton = connected_landfill_clickables.pop_back()
		landfill_clickable.queue_free()
		
		max_storage.set(Enums.ResourceType.BIOMASS, current_max_biomass - auto_expand_capacity_amount)
		ResourceSignals.add_input_building.emit(self)
