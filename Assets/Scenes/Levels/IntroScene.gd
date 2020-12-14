extends Node2D

func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN)

func _on_AnimationPlayer_animation_finished(anim_name):
	if anim_name == "Title":
		print("Trying to enter menu")
		SceneManager.goto_main_menu()
