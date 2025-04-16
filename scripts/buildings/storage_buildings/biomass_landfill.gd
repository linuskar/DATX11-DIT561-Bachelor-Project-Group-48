class_name BiomassLandfill
extends StorageBuilding
## A class that is for the aspects of a biomass landfill.
##
## A class that is for the aspects of a biomass landfill. This class extends from
## the StorageBuilding class.
##

var auto_expand_capacity_amount: int = 100

func  _process(delta: float) -> void:
	expand_landfill()

## Expansion function
func expand_landfill() -> void:
	var current_biomass: int = output_storage.get(Enums.ResourceType.BIOMASS)
	var current_max_biomass: int = max_storage.get(Enums.ResourceType.BIOMASS)
	if current_biomass >= current_max_biomass:
		max_storage.set(Enums.ResourceType.BIOMASS, current_max_biomass + auto_expand_capacity_amount)
		ResourceSignals.add_input_building.emit(self)
