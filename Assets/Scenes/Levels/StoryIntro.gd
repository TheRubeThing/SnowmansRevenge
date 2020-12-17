extends Node2D

func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN)

func _on_AnimationPlayer_animation_finished(anim_name):
	if anim_name == "Title":
		print("Trying to enter menu")
		GameData.current_level = 1
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
		SceneManager.goto_level(1)
