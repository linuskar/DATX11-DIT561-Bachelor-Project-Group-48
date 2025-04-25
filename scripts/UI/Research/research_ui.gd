extends UIMenu

var research_lab_selected: ResearchLab = null

func _ready() -> void:
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
