extends Node2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	if not GameData.persistent_data.has("Highest_completed_level"):
		GameData.persistent_data["Highest_completed_level"] = GameData.current_level
	if GameData.current_level > GameData.persistent_data["Highest_completed_level"]:
		GameData.persistent_data["Highest_completed_level"] = GameData.current_level
	GameData.save_game()


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
