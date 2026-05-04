class_name APICommunicator extends Node

var http_request: HTTPRequest

func _ready():
	http_request = HTTPRequest.new()
	add_child(http_request)
	
	http_request.request_completed.connect(_on_request_completed)


func upload_game_data(game_history: Array, game_result: Dictionary):
	var url = "http://127.0.0.1:8000/games/save"
	var headers = ["Content-Type: application/json"]
	
	var payload = {
		"player_score": game_result.final_player_score,
		"opponent_score": game_result.final_enemy_score,
		"winner": game_result.winner,
		"total_rounds": game_result.total_rounds,
		"history": game_history
	}
	
	http_request.request(url, headers, HTTPClient.METHOD_POST, JSON.stringify(payload))

func upload_game_data_by_json(game_save):
	var url = "http://127.0.0.1:8000/games/save"
	var headers = ["Content-Type: application/json"]
	
	http_request.request(url, headers, HTTPClient.METHOD_POST, JSON.stringify(game_save.data))


func _on_request_completed(result, response_code, headers, body):
	if response_code == 422:
		var error_message = body.get_string_from_utf8()
		print("FastAPI 422 Validation Error: ", error_message)
		return
		
	if response_code == 200:
		print("Success! Data saved.")
	return
