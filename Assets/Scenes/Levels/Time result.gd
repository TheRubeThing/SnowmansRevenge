extends RichTextLabel


func _ready():
	var minutes = int(GameData.completion_time) / 60
	var seconds = int(GameData.completion_time) % 60
	bbcode_text = "[center]Time: " + str(minutes) + ":" + str(seconds) + "[/center]"
