extends Node


var current_level = 0
var completion_time = 0
var persistent_data = {}

func load_game():
	var save_game = File.new()
	if not save_game.file_exists("user://savegame.save"):
		return
		
	save_game.open("user://savegame.save", File.READ)
	while not save_game.eof_reached():
		var game_data = parse_json(save_game.get_line())
		print(save_game.get_line())
		if game_data != null:
			persistent_data = game_data
		print("Loaded " + str(game_data))
	save_game.close()

func save_game():
	if persistent_data[str(current_level)] == null:
		persistent_data[str(current_level)] = completion_time
		
	var save_game = File.new()
	save_game.open("user://savegame.save", File.WRITE)
	save_game.store_line(to_json(persistent_data))
	print("Saved " + str(persistent_data))
	save_game.close()
	
