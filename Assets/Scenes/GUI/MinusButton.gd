extends Button


func _pressed():
	if GameData.current_level > 0:
		GameData.current_level -= 1
	$AudioStreamPlayer.play()
