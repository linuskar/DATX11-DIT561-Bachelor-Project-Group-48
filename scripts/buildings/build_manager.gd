class_name BuildManager
extends Node
## A class that manages the building aspect of the game.
##
## A class that manages the building aspect of the game by allowing the player
## via input to place out buildings in a grid based manner, checking 
## for valid placements. The buildings are preloaded in a dictionary.
##

## The blueprint previews the building you are about to place.
@export var blueprint: BuildingBlueprint
## The grid size of the map.
@export var grid_size: int = 32

## The layer the building is placed/locked on to get a grid based placement.
@onready var map_layer: MapLayer = $"../MapLayer"

## The currently occupied tiles, for example a building, tree, etc.
var occupied_tiles: Dictionary[Vector2, Building] = BuildManagerGlobal.occupied_tiles

## The colors highlighthing the placment of builings.
var valid_placement_color: Color = Color(0.5, 0.5, 1, 0.8) 
var invalid_placement_color: Color = Color(1, 0.5, 0.5, 0.8)
var default_color: Color = Color(1, 1, 1, 1)

## The buildings in the game that you can place.
@export var buildings: Dictionary[Enums.BuildingType, Resource]
## The blueprints for the buildings that you can place.
@export var building_blueprints: Dictionary[Enums.BuildingType, Resource]

## The buildings in the game that are currently placed.
var buildings_placed: Array[Building]

## The buildings in the game that are currently placed and gathering resources.
var buildings_gathering_resources: Array[Building]

## Boolean for checking valid placement.
var valid_placement: bool = false

## A signal for when a building is placed.
signal placed_building(building: Building)

func _ready() -> void:
	StateManager.build_mode.connect(_on_build_mode)
	StateManager.selected_building.connect(_on_selected_building)
	
## Function that gets called when a building is selected to build
func _on_selected_building(building_data: BuildingData) ->  void:
	StateManager.set_state(StateManager.State.SELECTED_BUILDING)
	## Delete the current blueprint
	blueprint.queue_free()
	
	## Add the new blueprint to the game of the currently selected building
	var new_blueprint: BuildingBlueprint = building_blueprints.get(building_data.building_type).instantiate()
	add_child(new_blueprint)
	blueprint = new_blueprint
	blueprint.show()
		
func _process(_delta) -> void:
	## In build mode snap the blueprint to the mouse in the world
	match StateManager.state:
		StateManager.State.SELECTED_BUILDING:
			_update_blueprint()
		StateManager.State.PLACE_BUILDING:
			_update_blueprint()

			if valid_placement:
				place_building()
		StateManager.State.IDLE:
			pass	

## Function for updating the placement of the building blueprint
func _update_blueprint():
	var grid_pos: Vector2 = get_snapped_world_position()
	blueprint.position = grid_pos 

	## Clamp the blueprint position to make it not go out the playable area
	var blueprint_size: Vector2 = blueprint.building_data.building_size
	blueprint.position = get_clamped_position_to_playable_area(blueprint.position, blueprint_size)
			
	## Checking for valid placement
	if are_tiles_occupied() or map_layer.can_place_building(blueprint) == false or not player_can_afford(blueprint):
		blueprint.modulate = invalid_placement_color
		valid_placement = false
	else:
		blueprint.modulate = valid_placement_color	
		valid_placement = true
		
## Function for getting a position that is clamped to the playable area
func get_clamped_position_to_playable_area(object_position: Vector2, size: Vector2) -> Vector2:
	var min_x: float = map_layer.map_areas.left_bound.position.x
	var max_x: float = map_layer.map_areas.right_bound.position.x

	var min_y: float = map_layer.map_areas.upper_bound.position.y
	var max_y: float = map_layer.map_areas.lower_bound.position.y
	
	var clamped_position: Vector2 = Vector2(0,0)
	clamped_position.x = clampf(object_position.x, min_x + grid_size * (size.x - 1) / 2, max_x - grid_size * (size.x - 1) / 2)
	clamped_position.y = clampf(object_position.y, min_y +  grid_size * (size.y -  1) / 2, max_y -  grid_size * (size.y -  1) / 2)
	
	return clamped_position
	
func _input(event: InputEvent) -> void:
	## When trying to place a building that is selected
	if event.is_action_pressed("place") and valid_placement and StateManager.state == StateManager.State.SELECTED_BUILDING:
		StateManager.set_state(StateManager.State.PLACE_BUILDING)
		
	## The case where the action for placing buildings is released
	if event.is_action_released("place") and StateManager.state == StateManager.State.PLACE_BUILDING:
		StateManager.set_state(StateManager.State.SELECTED_BUILDING)

## Function checking whether the player can afford the building.
## Returns false if the player cannot afford the building.
func player_can_afford(blueprint: BuildingBlueprint) -> bool:
	var cost: int = blueprint.building_data.building_cost
	return PlayerCurrency.player_held_currency >= cost

## Returns the world position of the mouse snapped to the nearest tile on the grid.
## This function converts the mouse position from world space to tile coordinates
## and then back to a snapped world position using a tilemap layer
func get_snapped_world_position() -> Vector2:
	## Don't know if this is the best. But one of TileMapLayers just gets picked
	## to get access to get the related functions to call
	var dirt_layer: TileMapLayer = map_layer.dirt_layer
	## Mouse position in world coordinates
	var world_mouse_pos: Vector2 = get_parent().get_global_mouse_position()  
	## Convert to local TileMap coordinates
	var local_mouse_pos: Vector2 = dirt_layer.to_local(world_mouse_pos)  
	## Get tile coordinates
	var tile_pos: Vector2i = dirt_layer.local_to_map(local_mouse_pos)  
	
	## Convert back to local position.
	var snapped_local_pos: Vector2 = dirt_layer.map_to_local(tile_pos)  
	var grid_pos: Vector2 = dirt_layer.to_global(snapped_local_pos)
	var blueprint_size: Vector2 = blueprint.building_data.building_size
	
	## To represent a top-left aligning placement along the grid.
	grid_pos += Vector2(grid_size * (blueprint_size.x - 1) / 2, 0)
	grid_pos += Vector2(0, grid_size * (blueprint_size.y -  1) / 2)
	## Return the world coordinates
	return grid_pos

## Function that is called when build mode signal is emitted
func _on_build_mode() -> void:
	match StateManager.state:
		## When not in build mode hide the blueprint
		StateManager.State.IDLE:
			blueprint.hide()  
			blueprint.modulate = default_color
		## When in build mode to place a building show the blueprint
		StateManager.State.SELECTED_BUILDING:
			blueprint.show()
			blueprint.modulate = valid_placement_color
			
## Function for placing down a building.
func place_building() -> void:
	## Instantiate the building and add it to the game and world
	var building_type: Enums.BuildingType = blueprint.building_data.building_type
	var new_building: Building = buildings.get(building_type).instantiate()
	new_building.position = blueprint.position
	get_parent().add_child(new_building)
	
	## Additionally decrease the players held currency equal to the cost of the building
	PlayerCurrency.remove_currency(blueprint.building_data.building_cost)
	_on_placed_building(new_building)
	
## Function checking if the tiles where the blueprint
## is are occupied by another object.
func are_tiles_occupied() -> bool:
	var blueprint_size: Vector2 = blueprint.building_data.building_size
	var adjusted_pos: Vector2 = blueprint.position 
	
	## Adjust the position to start in a top-left manner
	adjusted_pos -= Vector2(grid_size * (blueprint_size.x - 1) / 2, 0)
	adjusted_pos -= Vector2(0, grid_size * (blueprint_size.y -  1) / 2)
	## See if there are occupied tiles based on the blueprint size
	for x in range(blueprint_size.x):
		for y in range(blueprint_size.y):
			if occupied_tiles.has(adjusted_pos + Vector2(x *  grid_size, y * grid_size)):
				return true
	return false
	
## Function marking tiles as occupied for placing down a building
func _on_placed_building(building: Building) -> void:
	if building is BiomassLandfill:
		## TODO: Future implementantion, add button to stop auto expanding/shrinking
		## otherwise manually adding landfills wont work since the landfill will automatically shrink
		## the newly merged landfill, so right now it will just prevent from placing
		## two seperate landfill instances near each other, and waste money
		# var landfill_to_merge_with: BiomassLandfill = check_if_there_are_landfills_nearby(building, building.position)
		
		# if landfill_to_merge_with != null:
			# merge_landfills(building, landfill_to_merge_with)
		# else:
		# occupy_tiles(building, building.position) 
		# placed_building.emit(building)
		
		## Connect the funcxtions to auto expand and shrink
		building.landfill_expanded.connect(expand_landfill)
		building.landfill_shrinked.connect(shrink_landfill)
	# else:
	occupy_tiles(building, building.position) 
	placed_building.emit(building)

	BuildManagerGlobal.update_roads.emit()
	BuildManagerGlobal.print_networks()
	
## Function two merge landfills that are near each other
func merge_landfills(landfill_placed: BiomassLandfill, landfill_to_be_merged_with: BiomassLandfill) -> void:
	## Increase the max storage of the landfill.
	var current_biomass: int = landfill_to_be_merged_with.output_storage.get(Enums.ResourceType.BIOMASS)
	var current_max_biomass: int = landfill_to_be_merged_with.max_storage.get(Enums.ResourceType.BIOMASS)
	landfill_to_be_merged_with.max_storage.set(Enums.ResourceType.BIOMASS, current_max_biomass + landfill_to_be_merged_with.auto_expand_max_capacity_amount)
	# print("After: " + str(landfill_to_be_merged_with.max_storage))
	## Re-add landfill to request for input.
	ResourceSignals.add_input_building.emit(landfill_to_be_merged_with)
	
	## Create new sprite for where the landfill expands to.
	var new_sprite: Sprite2D = landfill_to_be_merged_with.building_sprite.duplicate()
	new_sprite.position = landfill_placed.position
	landfill_to_be_merged_with.add_child(new_sprite)
	landfill_to_be_merged_with.connected_landfill_sprites.append(new_sprite)
	
	## TODO: Add collision shape, but right now it is not relevant for any logic
	## var new_collision_shape: CollisionShape2D = null
	
	## Create new button for building info for where the landfill expands to
	var building_info_button: TextureButton = landfill_to_be_merged_with.clickable.duplicate()
	building_info_button.position = Vector2(landfill_placed.position)
	landfill_to_be_merged_with.add_child(building_info_button)
	landfill_to_be_merged_with.connected_landfill_clickables.append(building_info_button)
	
	## TODO: Add this in future implementation
	# var building_highlight: BuildingHighlight = landfill_to_be_merged_with
	
	## Occupy tiles for where the landfill expanded to
	var adjusted_pos: Vector2 = landfill_placed.position
	occupy_tiles(landfill_to_be_merged_with, adjusted_pos) 
	placed_building.emit(landfill_to_be_merged_with)
	
	landfill_placed.queue_free()
	
## Function that occupies tiles for a building.
func occupy_tiles(building: Building, position_to_adjust: Vector2) -> void:
	var building_tile_size: Vector2 = building.building_data.building_size
	var adjusted_pos: Vector2 = position_to_adjust
	
	## Adjust the position to start in a top-left manner
	adjusted_pos -= Vector2(grid_size * (building_tile_size.x - 1) / 2, 0)
	adjusted_pos -= Vector2(0, grid_size * (building_tile_size.y -  1) / 2)
	## Mark occupied tiles based on the building size
	for x in range(building_tile_size.x):
		for y in range(building_tile_size.y):
			occupied_tiles[adjusted_pos + Vector2(x * grid_size, y * grid_size)] = building

## Function that checks if there are landfills nearby for a landfill, returns null
## if no landfill is found
func check_if_there_are_landfills_nearby(landfill, current_tile: Vector2) -> BiomassLandfill:
	## look at directions
	var position_to_expand_to: Vector2 = Vector2(0,0)
	## Shuffle the possible directions to get a randomized selection
	var directions = Enums.Direction.values()
	directions.shuffle()
	
	var valid_tile_types_to_place: Array[Enums.TileType] = landfill.building_data.valid_tile_types_to_place_on
	var size: Vector2 = landfill.building_data.building_size
	
	## Look at the tiles around in the possible directions
	for direction in directions:
		match direction:
			Enums.Direction.UP:
				position_to_expand_to = Vector2(0, -grid_size) + current_tile
			Enums.Direction.DOWN:
				position_to_expand_to = Vector2(0, grid_size) + current_tile
			Enums.Direction.LEFT:
				position_to_expand_to = Vector2(-grid_size, 0) + current_tile
			Enums.Direction.RIGHT:
				position_to_expand_to = Vector2(grid_size, 0) + current_tile
			
		var position_to_check: Vector2 = position_to_expand_to
		position_to_check = get_clamped_position_to_playable_area(position_to_check, size)

		## If the position has a landfill
		if occupied_tiles.has(position_to_check):
			var building: Building = occupied_tiles.get(position_to_check)

			if building is BiomassLandfill:
				return building
		position_to_expand_to = Vector2(0,0)
	return null
			
## Expand the landfill when at max capacity
func expand_landfill(landfill: BiomassLandfill) -> void:
	## Set the next position to expand to
	next_position_to_expand_to(landfill, landfill.connected_landfill_sprites.size() - 1)

	## If there is no possible position that the landfill can expand to.
	if landfill.position_to_expand_to.x == 0 and landfill.position_to_expand_to.y == 0:
		return

	## Increase the max storage of the landfill.
	var current_biomass: int = landfill.output_storage.get(Enums.ResourceType.BIOMASS)
	var current_max_biomass: int = landfill.max_storage.get(Enums.ResourceType.BIOMASS)
	landfill.max_storage.set(Enums.ResourceType.BIOMASS, current_max_biomass + landfill.auto_expand_max_capacity_amount)
	## Re-add landfill to request for input.
	ResourceSignals.add_input_building.emit(landfill)
	
	## Create new sprite for where the landfill expands to.
	var new_sprite: Sprite2D = landfill.building_sprite.duplicate()
	new_sprite.position += landfill.position_to_expand_to
	landfill.add_child(new_sprite)
	landfill.connected_landfill_sprites.append(new_sprite)
	
	## Create new higlight for where the landfill expands to
	var building_highlight: BuildingHighlight = landfill.highlight.duplicate()
	building_highlight.position += Vector2(landfill.position_to_expand_to)
	landfill.add_child(building_highlight)
	landfill.higlights_list.append(building_highlight)
	
	## TODO: Add collision shape, but right now it is not relevant for any logic
	## var new_collision_shape: CollisionShape2D = null
	
	## Create new button for building info for where the landfill expands to
	var building_info_button: TextureButton = landfill.clickable.duplicate()
	building_info_button.position += Vector2(landfill.position_to_expand_to)
	landfill.add_child(building_info_button)
	landfill.connected_landfill_clickables.append(building_info_button)

	landfill.place_animation.play()
	
	## Occupy tiles for where the landfill expanded to
	var adjusted_pos: Vector2 = landfill.position + landfill.position_to_expand_to
	occupy_tiles(landfill, adjusted_pos) 
	placed_building.emit(landfill)
	
	## TODO: Future implementation for merging landfills when auto expanding
	## NOTE: have to take care of the resources that are currently transporting
	## need to somehow reroute the resoruces that are transported to the current instance of landfill
	# var landfill_to_merge_with: BiomassLandfill = check_if_there_are_landfills_nearby(landfill, adjusted_pos)
	# merge_landfills(landfill, landfill_to_merge_with)

## Set the next position that a landfill can expand to.
func next_position_to_expand_to(landfill: BiomassLandfill, index: int) -> void:
		var prev_occupied_tile_pos: Vector2 = Vector2(0,0)
		
		## Go through all tiles the landfill occupies
		if index >= 0:
			prev_occupied_tile_pos = landfill.connected_landfill_sprites[index].position
		else:
			## When there is only one tile the landfill occupies
			landfill.position_to_expand_to = get_possible_position_to_expand_to(landfill, prev_occupied_tile_pos)
			return

		landfill.position_to_expand_to = get_possible_position_to_expand_to(landfill, prev_occupied_tile_pos)
		
		## If no direction was possible for previously occupied tile by the landfill
		if landfill.position_to_expand_to.x == 0 and landfill.position_to_expand_to.y == 0:
			next_position_to_expand_to(landfill, index - 1)
			
## Look at tiles by the possible directions around a tile, to get a position to
## expand to.
func get_possible_position_to_expand_to(landfill: BiomassLandfill, current_tile: Vector2) -> Vector2:
	var occupied_tiles: Array[Vector2] = BuildManagerGlobal.occupied_tiles.keys()
	var position_to_expand_to: Vector2 = Vector2(0,0)
	## Shuffle the possible directions to get a randomized selection
	var directions = Enums.Direction.values()
	directions.shuffle()
	
	var valid_tile_types_to_place: Array[Enums.TileType] = landfill.building_data.valid_tile_types_to_place_on
	var size: Vector2 = landfill.building_data.building_size
	
	## Look at the tiles around in the possible directions
	for direction in directions:
		match direction:
			Enums.Direction.UP:
				position_to_expand_to = Vector2(0, -grid_size) + current_tile
			Enums.Direction.DOWN:
				position_to_expand_to = Vector2(0, grid_size) + current_tile
			Enums.Direction.LEFT:
				position_to_expand_to = Vector2(-grid_size, 0) + current_tile
			Enums.Direction.RIGHT:
				position_to_expand_to = Vector2(grid_size, 0) + current_tile
			
		var position_to_check: Vector2 = position_to_expand_to + landfill.position
		position_to_check = get_clamped_position_to_playable_area(position_to_check, size)
		
		## If the position is valid to expand to
		if !(position_to_check in occupied_tiles) and map_layer.check_valid_tile(position_to_check, valid_tile_types_to_place):
			return position_to_expand_to
			
		position_to_expand_to = Vector2(0,0)
	## Return an invalid position to expand to
	return position_to_expand_to
	
## Shrink the landfill when the current amount of biomass is below a certain threshold
func shrink_landfill(landfill: BiomassLandfill) -> void:
	## Decrease the max storage of the landfill
	var current_biomass: int = landfill.output_storage.get(Enums.ResourceType.BIOMASS)
	var current_max_biomass: int = landfill.max_storage.get(Enums.ResourceType.BIOMASS)
	landfill.max_storage.set(Enums.ResourceType.BIOMASS, current_max_biomass - landfill.auto_expand_max_capacity_amount)

	## Deoccupy the tile that the landfill previously occupied
	## Remove corresponding sprite and clickable button
	var landfill_sprite: Sprite2D = landfill.connected_landfill_sprites.pop_back()
	occupied_tiles.erase(landfill_sprite.position)
	landfill_sprite.queue_free()
	
	var landfill_clickable: TextureButton = landfill.connected_landfill_clickables.pop_back()
	landfill_clickable.queue_free()
	
	landfill.place_animation.play()
	
	## Re-add landfill to request for input
	ResourceSignals.add_input_building.emit(landfill)

## When the mouse has entered the building list:
## Disable the state of placing a building and hide the blueprint
func _on_user_interface_build_list_entered() -> void:
	StateManager.set_state(StateManager.State.IDLE)
	_on_build_mode()

## Receiver for ui_status signal in UserInterface
## Disables building ability if the mouse is in any ui element
func set_ui_status(status: bool) -> void:
	if status:
		StateManager.set_state(StateManager.State.IDLE)
		_on_build_mode()

## When the mouse has exited the building list with a selected building:
## Set the currently selected building and show its blueprint
func _on_user_interface_building_wanted(building: BuildingData) -> void:
	if not building == null:
		StateManager.set_state(StateManager.State.SELECTED_BUILDING)
		_on_selected_building(building)
		_on_build_mode()
