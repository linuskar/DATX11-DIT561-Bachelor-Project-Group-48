class_name IronMine
extends GatheringBuilding
## A class that is for the aspects of an iron mine.
##
## A class that is for the aspects of an iron mine. This class extends from
## the GatheringBuilding class.
##

func _ready():
	$place_animation.play("place")
	super()

func _on_place_animation_animation_finished(anim_name: StringName) -> void:
	$place_particle.emitting = true

func apply_research_upgrade(research_data: ResearchData) -> void:
	if research_data.research_id == Enums.ResearchID.IM_1:
		var iron_gather_rate: int = output_generation.get(Enums.ResourceType.IRON_ORE)
		output_generation.set(Enums.ResourceType.IRON_ORE, iron_gather_rate + 5)
