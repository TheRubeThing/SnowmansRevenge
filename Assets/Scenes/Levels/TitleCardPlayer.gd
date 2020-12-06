extends AnimationPlayer


func _ready():
	play("Maker")
	get_parent().get_node("AudioStreamPlayer").play()
	queue("Production")
	queue("Title")
