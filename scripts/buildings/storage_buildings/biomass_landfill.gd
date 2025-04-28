class_name BiomassLandfill
extends StorageBuilding
## A class that is for the aspects of a biomass landfill.
##
## A class that is for the aspects of a biomass landfill. This class extends from
## the StorageBuilding class.
##

var auto_expand_max_capacity_amount: int = 100
var connected_landfills: Array[LandfillAutoExpand] = []
var grid_size: int = 32
var position_to_expand_to: Vector2 = Vector2(0, 0)

@onready var place_animation: AnimationPlayer = $place_animation
@onready var place_particle: GPUParticles2D = $place_particle

signal landfill_expanded(landfill: BiomassLandfill)
signal landfill_shrinked(landfill: BiomassLandfill)

@onready var clickable: Clickable = $Clickable

var landfill_auto_expand: PackedScene = preload("res://scenes/buildings/storage_buildings/landfill_auto_expand.tscn")

func _ready() -> void:
	super()
	place_animation.play("place")
	
func  _process(delta: float) -> void:
	expand_landfill()
	shrink_landfill()
	highlight_building()

## Expand the landfill when at max capacity
func expand_landfill() -> void:
	var current_biomass: int = output_storage.get(Enums.ResourceType.BIOMASS)
	var current_max_biomass: int = max_storage.get(Enums.ResourceType.BIOMASS)
	
	if current_biomass >= current_max_biomass:
		landfill_expanded.emit(self)
	
## Shrink the landfill below a threshold for the max capacity
func shrink_landfill() -> void:
	var current_biomass: int = output_storage.get(Enums.ResourceType.BIOMASS)
	var current_max_biomass: int = max_storage.get(Enums.ResourceType.BIOMASS)

	if (current_biomass < (current_max_biomass - auto_expand_max_capacity_amount)) and connected_landfills.size() > 0:
		landfill_shrinked.emit(self)

## Function to higlight the all the connected landfills
func highlight_building() -> void:
	if currently_selected:
		highlight.selected()
		for landfill in connected_landfills:
			landfill.highlight.selected()
	else:
		highlight.unselected()
		for landfill in connected_landfills:
			landfill.highlight.unselected()

func instantiate_auto_expand_landfill() -> void:
	var landfill_auto: LandfillAutoExpand = landfill_auto_expand.instantiate()
	add_child(landfill_auto)
	landfill_auto.position = position_to_expand_to
	connected_landfills.append(landfill_auto)

func _on_place_animation_animation_finished(anim_name: StringName) -> void:
	place_particle.emitting = true
