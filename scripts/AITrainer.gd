class_name AITrainer extends Node

var http_request: HTTPRequest

func _ready():
	http_request = HTTPRequest.new()
	add_child(http_request)
	
	http_request.request_completed.connect(_on_request_completed)


func request_training():
	var url = "https://gamewebai.onrender.com/ai/run_training"
	var headers = ["Content-Type: application/json"]
	
	http_request.request(url, headers, HTTPClient.METHOD_POST)

func request_reinforcement():
	var url = "https://gamewebai.onrender.com/ai/run_reinforcement"
	var headers = ["Content-Type: application/json"]
	
	http_request.request(url, headers, HTTPClient.METHOD_POST)


func _on_request_completed(result, response_code, headers, body):
	if response_code == 200 or response_code == 201:
		print("Success!")
	else:
		print("Failed", " Code: ", response_code)
