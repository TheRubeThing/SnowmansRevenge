extends RichTextLabel


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _process(delta):
	var _level_text
	if GameData.current_level == 0:
		_level_text = "Intro"
	elif GameData.current_level == 6:
		_level_text = "Credits"
	else:
		_level_text = str(GameData.current_level)
	bbcode_text = "[center]" + _level_text + "[/center]"
