class_name MainMenu extends Node

var api_communicator: APICommunicator

@onready var main_game : String = "res://scenes/MainGame.tscn"


func _ready() -> void:
	
	api_communicator = APICommunicator.new()
	add_child(api_communicator)


func _on_upload_button_pressed() -> void:
	#temporarily testing one one file
	var game_save = load("res://game_saves/save.json")
	api_communicator.upload_game_data_by_json(game_save)
	
	pass # Replace with function body.


func _on_play_button_pressed() -> void:
	var main_game_screen = load(main_game).instantiate()
	
	#add_child(main_game_screen)
	#adapt to swapping screens, not just adding it on top
