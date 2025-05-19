class_name RocketLaunchPad
extends StorageBuilding

func _on_place_animation_animation_finished(anim_name: String) -> void:
	super(anim_name)
	get_tree().root.get_node("Game/UserInterface/GameWinUI").show()
