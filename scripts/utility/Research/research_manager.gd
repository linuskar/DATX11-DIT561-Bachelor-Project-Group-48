extends Node
class_name ResearchManager

# Signal sent when research is completed
signal research_completed(research_id: String)

# A list storing the IDs of completed research 
var completed_research: Array[String] = []

# Function for completing research
func complete_research(research_id: String) -> void:
	if completed_research.has(research_id):
		return
		
	completed_research.append(research_id)			# Add to the completed list
	print("Research completed:", research_id) 		# For debuging
	emit_signal("research_completed", research_id)	# Emit the signal

# Function to check for already completed research 
# (Probably useful when you place a new building)
func has_completed(research_id: String) -> bool:
	return research_id in completed_research
