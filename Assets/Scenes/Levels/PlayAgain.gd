extends Button


func _pressed():
	$AudioStreamPlayer.play()
	SceneManager.goto_level(GameData.current_level)
