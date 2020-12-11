extends Area2D





func _on_KillBox_body_entered(body):
	if body.is_in_group("Player"):
		body.damage(300)
