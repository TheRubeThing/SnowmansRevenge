extends Node2D

var _old_level
var _new_level

func set_next_level(level : PackedScene):
	$FadeAnimations.play("BlackFadeIn")
	_old_level = $Level
	_new_level = level
	
func _on_Level_Loaded():
	$FadeAnimations.queue("BlackFadeOut")

func _on_FadeAnimations_animation_finished(anim_name):
	if anim_name == "BlackFadeIn":
		remove_child(_old_level)
		_old_level.queue_free()
		
		var level_instance = _new_level.instance()
		level_instance.connect("tree_entered", self, "_on_Level_Loaded")
		level_instance.set_name("Level")
		add_child(level_instance)
