class_name BiomassLandfill
extends StorageBuilding
## A class that is for the aspects of a biomass landfill.
##
## A class that is for the aspects of a biomass landfill. This class extends from
## the StorageBuilding class.
##

var auto_expand_max_capacity_amount: int = 100
var connected_landfill_sprites: Array[Sprite2D] = []
var connected_landfill_clickables: Array[TextureButton] = []
var grid_size: int = 32
var position_to_expand_to: Vector2 = Vector2(0, 0)

signal landfill_expanded(landfill: BiomassLandfill)
signal landfill_shrinked(landfill: BiomassLandfill)

@onready var clickable: TextureButton = $Clickable
@onready var highlight: BuildingHighlight = $Highlight

var higlights_list: Array[BuildingHighlight]
var currently_selected: bool

func _ready() -> void:
	super()
	highlight.hide()
	higlights_list.append(highlight)
	BuildingSignals.building_clicked.connect(building_selected)
	BuildingSignals.building_info_closed.connect(building_deselected)
	
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

	if (current_biomass < (current_max_biomass - auto_expand_max_capacity_amount)) and connected_landfill_sprites.size() > 0:
		landfill_shrinked.emit(self)

func building_selected(building: Building) -> void:
	if building == self:
		currently_selected = true
	else:
		currently_selected = false

func building_deselected(building: Building) -> void:
	if building == self:
		currently_selected = false

func highlight_building() -> void:
	if currently_selected:
		for building_highlight in higlights_list:
			building_highlight.show()
			building_highlight.selected()
	else:
		for building_highlight in higlights_list:
			building_highlight.hide()
			building_highlight.de_selected()
