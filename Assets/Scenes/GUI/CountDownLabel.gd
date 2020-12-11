extends RichTextLabel


func _process(delta):
	var minutes = floor(get_node("../Timer").time_left / 60)
	var seconds = int(get_node("../Timer").time_left) % 60
	text = str(minutes) + ":" + str(seconds)
