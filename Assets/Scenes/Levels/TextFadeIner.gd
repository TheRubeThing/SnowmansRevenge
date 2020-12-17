extends Area2D



var _played = false

func _on_Area2D_body_entered(body):
	if body.is_in_group("Player") && not _played:
		_played = true
		$AnimationPlayer.play("FadeInText")
