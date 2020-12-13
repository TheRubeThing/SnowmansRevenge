extends Node2D

var _current_scene = null

var _levels = {
	1: "res://Assets/Scenes/Levels/Level1.tscn",
	2: "res://Assets/Scenes/Levels/Level2.tscn",
	3: "res://Assets/Scenes/Levels/LevelBig.tscn",
	4: "res://Assets/Scenes/Levels/TestLevel.tscn"
}
	
func _ready():
	var root = get_tree().get_root()
	_current_scene = root.get_child(root.get_child_count() - 1)
	
func fade_in():
	$FadeAnimations.play("BlackFadeIn")
	
func goto_main_menu():
	goto_scene("res://Assets/Scenes/Levels/MainMenu.tscn")
	
func goto_next_level_screen():
	goto_scene("res://Assets/Scenes/Levels/NextLevelScreen.tscn")
	
func goto_game_over():
	goto_scene("res://Assets/Scenes/Levels/GameOverScreen.tscn")
	
func goto_level(level: int):
	GameData.current_level = level
	print("Accessing level: " + str(level) + " : " + _levels[level])
	goto_scene(_levels[level])
	
func goto_scene(path):
	# This function will usually be called from a signal callback,
	# or some other function in the current scene.
	# Deleting the current scene at this point is
	# a bad idea, because it may still be executing code.
	# This will result in a crash or unexpected behavior.

	# The solution is to defer the load to a later time, when
	# we can be sure that no code from the current scene is running:
	$FadeAnimations.play("BlackFadeIn")
	yield($FadeAnimations, "animation_finished")
	call_deferred("_deferred_goto_scene", path)
	
func _deferred_goto_scene(path):
	# It is now safe to remove the current scene
	_current_scene.free()

	# Load the new scene.
	var s = ResourceLoader.load(path)

	# Instance the new scene
	assert(s != null)
	_current_scene = s.instance()

	# Add it to the active scene, as child of root.
	get_tree().get_root().add_child(_current_scene)

	# Optionally, to make it compatible with the SceneTree.change_scene() API.
	get_tree().set_current_scene(_current_scene)
	$FadeAnimations.play("BlackFadeOut")
