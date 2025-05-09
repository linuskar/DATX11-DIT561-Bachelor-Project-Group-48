class_name CoalMine
extends GatheringBuilding
## A class that is for the aspects of a coal mine.
##
## A class that is for the aspects of a coal mine. This class extends from
## the GatheringBuilding class.
##

func _ready():
	super()

func apply_research_upgrade(research_data: ResearchData) -> void:
	if research_data.research_id == Enums.ResearchID.CM_1:
		var coal_gather_rate: int = output_generation.get(Enums.ResourceType.COAL)
		output_generation.set(Enums.ResourceType.COAL, coal_gather_rate + 5)
