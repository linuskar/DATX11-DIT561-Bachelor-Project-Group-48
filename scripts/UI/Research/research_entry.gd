extends Button
class_name ResearchEntry

var research_data: ResearchData

@onready var name_label: Label = $HBoxContainer/LeftContainer/VBoxContainer/Name
@onready var description_label: Label = $HBoxContainer/LeftContainer/VBoxContainer/Description
@onready var cost_label: Label = $HBoxContainer/LeftContainer/VBoxContainer/Cost

func _ready() -> void:
	if research_data:
		name_label.text = research_data.research_name
		description_label.text = research_data.description
		cost_label.text = "Cost: FREE"  # Placeholder

		#if Research.has_completed(research_data.research_id):
		#	disabled = true

		connect("pressed", _on_pressed)
		ResearchSignals.research_completed.connect(disable_research_entry)

func disable_research_entry(research_data: ResearchData) -> void:
	disabled = true

func _on_pressed() -> void:
	#if Research.has_completed(research_data.research_id):
	#	return

	#Research.complete_research(research_data.research_id)
	
	ResearchSignals.research_clicked.emit(research_data)
	ResearchSignals.research_completed
	disabled = true
