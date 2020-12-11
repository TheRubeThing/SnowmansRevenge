extends Button


func _pressed():
	SceneManager.goto_level(GameData.current_level + 1)
