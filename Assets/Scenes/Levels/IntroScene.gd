extends Node2D

export(PackedScene) var next_level

func _on_AnimationPlayer_animation_finished(anim_name):
	if anim_name == "Title":
		var parent = get_parent()
		if parent != null && next_level != null:
			get_parent().set_next_level(next_level)
		else:
			print("Failed to load next scene")
