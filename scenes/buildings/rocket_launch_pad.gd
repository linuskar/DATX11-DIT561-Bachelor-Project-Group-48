class_name RocketLaunchPad
extends StorageBuilding

func _on_place_animation_animation_finished(anim_name: String) -> void:
	super(anim_name)
	print("win")
