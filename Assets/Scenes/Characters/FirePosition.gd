extends Position2D

var snowball : PackedScene = preload("res://Assets/Scenes/Attacks/Snowball.tscn")

signal fired()

func _input(event):
	if event.is_action_pressed("Fire"):
		print("Fire")
		var projectile = snowball.instance()
		get_parent().get_parent().get_parent().add_child(projectile)
		projectile.position = to_global(position)
		projectile.set_direction(get_global_mouse_position() - to_global(position))
		emit_signal("fired")
