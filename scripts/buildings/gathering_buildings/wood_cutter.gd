class_name WoodCutter
extends GatheringBuilding
## A class that is for the aspects of a wood cutter.
##
## A class that is for the aspects of an wood cutter. This class extends from
## the GatheringBuilding class.
##


func _ready():
	super()
	apply_research_upgrade()
	Research.research_completed.connect(_on_research_completed)

func _on_research_completed(id: String) -> void:
	apply_research_upgrade()

func apply_research_upgrade() -> void:
	if Research.has_completed("WC1"):
		print("WC1 applied to ", name)
	
