extends Node2D

func _on_AnimationPlayer_animation_finished(anim_name):
	if anim_name == "Title":
		print("Trying to enter menu")
		SceneManager.goto_main_menu()
