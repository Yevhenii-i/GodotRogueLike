class_name GameLogger extends Node

#it needs to be changed to create unique save name each time
func save_game(game_history: Array, game_result: Dictionary):
	var current_timestamp = int(Time.get_unix_time_from_system()*1000)
	var save_file = FileAccess.open("res://game_saves/not_uploaded/save"+ str(current_timestamp) +".dat", FileAccess.WRITE)
	
	var game_data = {
		"player_score": game_result.final_player_score,
		"opponent_score": game_result.final_enemy_score,
		"winner": game_result.winner,
		"total_rounds": game_result.total_rounds,
		"history": game_history
	}
	
	var json_string = JSON.stringify(game_data)
	save_file.store_line(json_string)
	save_file.close()
	print("Saved!")
