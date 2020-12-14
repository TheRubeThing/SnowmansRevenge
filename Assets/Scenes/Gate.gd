extends StaticBody2D


func _on_Gate_Trigger():
	$AnimatedSprite.play("Open")
	$GateSound.play()
	

func _on_Gate_animation_finished():
	$CollisionShape2D.disabled = true
