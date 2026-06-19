class_name GameUploader extends Node

const NOT_UPLOADED_DIR = "user://game_saves/not_uploaded/"
const UPLOADED_DIR = "user://game_saves/uploaded/"

var http_request: HTTPRequest

var url = "https://gamewebai.onrender.com/games/save"
var headers = ["Content-Type: application/json"]

var upload_queue: Array[String] = []
var current_file_path: String = ""

func _ready():
	http_request = HTTPRequest.new()
	add_child(http_request)
	var dir = DirAccess.open("user://")
	if not dir.dir_exists("user://game_saves/"):
		dir.make_dir_recursive("user://game_saves/")
	
	dir = DirAccess.open("user://game_saves/")
	if not dir.dir_exists(NOT_UPLOADED_DIR):
		dir.make_dir_recursive(NOT_UPLOADED_DIR)
	if not dir.dir_exists(UPLOADED_DIR):
		dir.make_dir_recursive(UPLOADED_DIR)
	
	http_request.request_completed.connect(_on_request_completed)


func start_sync_process():
	if upload_queue.is_empty():
		var files = DirAccess.get_files_at(NOT_UPLOADED_DIR)
		for f in files:
			if f.ends_with(".dat"):
				upload_queue.append(f)
	
	upload_next_in_queue()


func upload_next_in_queue():
	if upload_queue.is_empty():
		print("All files are uploaded and moved.")
		return
		
	current_file_path = upload_queue.pop_front()
	var full_path = NOT_UPLOADED_DIR + current_file_path
	
	var file = FileAccess.open(full_path, FileAccess.READ)
	if not file:
		print("Could not read file: ", current_file_path)
		upload_next_in_queue()
		return
		
	var json_string = file.get_as_text()
	var json_data = JSON.parse_string(json_string)
	file.close()
	
	print("Uploading: ", current_file_path)
	http_request.request(url, headers, HTTPClient.METHOD_POST, JSON.stringify(json_data))


func move_file_to_uploaded(file_name: String):
	var old_path = NOT_UPLOADED_DIR + file_name
	var new_path = UPLOADED_DIR + file_name
	var dir = DirAccess.open("user://game_saves/")
	
	if dir.file_exists(new_path):
		dir.remove(new_path)
		
	var error = dir.rename(old_path, new_path)
	if error == OK:
		print("Moved to uploaded: ", file_name)
	else:
		print("Error moving file: ", error)


func upload_all_game_data(path: String):
	var dir = DirAccess.open(path)
	if not dir:
		push_error("Invalid dir: " + path)
		return
	
	dir.list_dir_begin()
	var file_name = dir.get_next()
	while file_name != "":
		var game_save = load(path + file_name)
		upload_game_data_by_json(game_save)


func upload_game_data(game_history: Array, game_result: Dictionary):
	var payload = {
		"player_score": game_result.final_player_score,
		"opponent_score": game_result.final_enemy_score,
		"winner": game_result.winner,
		"total_rounds": game_result.total_rounds,
		"history": game_history
	}
	
	http_request.request(url, headers, HTTPClient.METHOD_POST, JSON.stringify(payload))

func upload_game_data_by_json(game_save):
	http_request.request(url, headers, HTTPClient.METHOD_POST, JSON.stringify(game_save.data))


func upload_game_data_by_filename(filename: String):
	var game_save = load(filename)
	
	http_request.request(url, headers, HTTPClient.METHOD_POST, JSON.stringify(game_save.data))


func _on_request_completed(_result, response_code, _headers, _body):
	if response_code == 200 or response_code == 201:
		move_file_to_uploaded(current_file_path)
		upload_next_in_queue()
	else:
		print("Failed to upload ", current_file_path, " Code: ", response_code)
		current_file_path = ""
