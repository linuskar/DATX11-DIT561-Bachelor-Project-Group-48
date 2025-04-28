class_name Landfill
extends StorageBuilding
## A class that is for the aspects of a landfill.
##
## A class that is for the aspects of a landfill. This class extends from
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
@onready var highlight: BuildingHighlight = $Highlight

var landfill_auto_expand: PackedScene = preload("res://scenes/buildings/storage_buildings/landfill_auto_expand.tscn")

var currently_selected: bool

@export var main_resource: Enums.ResourceType

func _ready() -> void:
	super()
	place_animation.play("place")
	highlight.hide()
	BuildingSignals.building_clicked.connect(building_selected)
	BuildingSignals.building_info_closed.connect(building_deselected)
	
func  _process(delta: float) -> void:
	expand_landfill()
	shrink_landfill()
	highlight_building()

## Expand the landfill when at max capacity
func expand_landfill() -> void:
	var current_resource_stored: int = output_storage.get(main_resource)
	var current_max_resource: int = max_storage.get(main_resource)
	
	if current_resource_stored >= current_max_resource:
		landfill_expanded.emit(self)
	
## Shrink the landfill below a threshold for the max capacity
func shrink_landfill() -> void:
	var current_resource_stored: int = output_storage.get(main_resource)
	var current_max_resource: int = max_storage.get(main_resource)

	if (current_resource_stored < (current_max_resource - auto_expand_max_capacity_amount)) and connected_landfills.size() > 0:
		landfill_shrinked.emit(self)
		
## Function to set building as currently selected
func building_selected(building: Building) -> void:
	if building == self:
		currently_selected = true
	else:
		currently_selected = false
		
## Function to set building as not currently selected
func building_deselected(building: Building) -> void:
	if building == self:
		currently_selected = false

## Function to higlight the all the connected landfills
func highlight_building() -> void:
	if currently_selected:
		highlight.show()
		highlight.selected()
		for landfill in connected_landfills:
			landfill.highlight.show()
			landfill.highlight.selected()
	else:
		highlight.hide()
		highlight.de_selected()
		for landfill in connected_landfills:
			landfill.highlight.hide()
			landfill.highlight.de_selected()

func instantiate_auto_expand_landfill() -> void:
	var landfill_auto: LandfillAutoExpand = landfill_auto_expand.instantiate()
	landfill_auto.texture = self.building_sprite.texture
	add_child(landfill_auto)
	landfill_auto.position = position_to_expand_to
	connected_landfills.append(landfill_auto)

func _on_place_animation_animation_finished(anim_name: StringName) -> void:
	place_particle.emitting = true
