extends UIMenu

@onready var v_box_container: VBoxContainer = $ScrollContainer/VBoxContainer

@export var available_research: Array[ResearchData]

var research_lab_selected: ResearchLab = null
var research_entry_scene: Resource = preload("res://scenes/UI/ResearchUI/Research_Entry.tscn")
var research_entries: Array[ResearchEntry]

func _ready() -> void:
	super()
	
	for research in available_research:
		var research_entry: ResearchEntry = research_entry_scene.instantiate()
		research_entry.research_data = research
		v_box_container.add_child(research_entry)	
	
	hide()

#Open UI
func open(research_lab_clicked: ResearchLab) -> void:
	research_lab_selected = research_lab_clicked
	research_lab_selected.currently_selected = true
	show()

#Close UI
func close() -> void:
	research_lab_selected.currently_selected = false
	hide()
