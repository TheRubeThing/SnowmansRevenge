extends RichTextLabel


func _ready():
	if not GameData.persistent_data.has(str(GameData.current_level)):
		GameData.persistent_data[str(GameData.current_level)] = GameData.completion_time
	if GameData.completion_time < GameData.persistent_data[str(GameData.current_level)]:
		GameData.persistent_data[str(GameData.current_level)] = GameData.completion_time
		
	var best_time = GameData.persistent_data[str(GameData.current_level)]
	var minutes = int(best_time) / 60
	var seconds = int(best_time) % 60
	bbcode_text = "[center]Best time: " + str(minutes) + ":" + str(seconds) + "[/center]"
