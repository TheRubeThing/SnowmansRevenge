extends Button

func _pressed():
	if GameData.persistent_data.has("Highest_completed_level"):
		if GameData.current_level <= GameData.persistent_data["Highest_completed_level"]:
			GameData.current_level += 1
	$AudioStreamPlayer.play()
