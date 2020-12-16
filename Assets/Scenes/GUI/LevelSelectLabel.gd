extends RichTextLabel


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _process(delta):
	bbcode_text = "[center]" + str(GameData.current_level) + "[/center]"
