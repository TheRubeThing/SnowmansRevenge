extends Button


func _pressed():
	$AudioStreamPlayer.play()
	SceneManager.fade_in()
	yield(get_tree().create_timer(1.0), "timeout")
	get_tree().quit()
