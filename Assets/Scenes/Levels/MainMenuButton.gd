extends Button

export(PackedScene) var next_level

func _pressed():
	$AudioStreamPlayer.play()
	SceneManager.goto_main_menu()
