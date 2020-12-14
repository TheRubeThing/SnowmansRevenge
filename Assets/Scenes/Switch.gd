extends AnimatedSprite

signal triggered()

func _process(delta):
	if Input.is_action_just_pressed("Switch"):
		for body in $Area2D.get_overlapping_bodies():
			if body.is_in_group("Player"):
				play("ON")
				emit_signal("triggered")
				$"SwitchSound".play()
				
				
