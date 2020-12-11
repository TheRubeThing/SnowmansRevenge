extends Button

export(PackedScene) var next_level

func _pressed():
	SceneManager.goto_main_menu()
