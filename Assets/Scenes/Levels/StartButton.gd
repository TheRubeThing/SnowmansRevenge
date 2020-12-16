extends Button

export(PackedScene) var next_level

func _pressed():
	$AudioStreamPlayer.play()
	yield(get_tree().create_timer(0.5), "timeout")
	SceneManager.goto_level(GameData.current_level)
