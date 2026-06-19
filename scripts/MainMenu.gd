class_name MainMenu extends Node

var game_uploader: GameUploader
var ai_trainer: AITrainer
var game_starter: GameStarter

@onready var mainGame : String = "res://scenes/MainGame.tscn"
@onready var UIElements = $"UI Elements"

var main_game_scene : PackedScene
var main_game_instance : Node


func _ready() -> void:
	game_uploader = GameUploader.new()
	add_child(game_uploader)
	ai_trainer = AITrainer.new()
	add_child(ai_trainer)
	game_starter = GameStarter.new()
	add_child(game_starter)


func _on_upload_button_pressed() -> void:
	game_uploader.start_sync_process()


func _on_play_button_pressed() -> void:
	UIElements.set_visible(false)
	UIElements.mouse_filter = Control.MOUSE_FILTER_IGNORE
	await game_starter.start_human_game(3)
	UIElements.set_visible(true)
	UIElements.mouse_filter = Control.MOUSE_FILTER_STOP


func _on_training_button_pressed() -> void:
	UIElements.set_visible(false)
	UIElements.mouse_filter = Control.MOUSE_FILTER_IGNORE
	await game_starter.start_simulation_games(10, "training")
	UIElements.set_visible(true)
	UIElements.mouse_filter = Control.MOUSE_FILTER_STOP


func _on_reinforce_button_pressed() -> void:
	UIElements.set_visible(false)
	UIElements.mouse_filter = Control.MOUSE_FILTER_IGNORE
	await game_starter.start_simulation_games(1, "reinforcement")
	UIElements.set_visible(true)
	UIElements.mouse_filter = Control.MOUSE_FILTER_STOP


func _on_train_request_button_pressed() -> void:
	ai_trainer.request_training()


func _on_play_button_2_pressed() -> void:
	UIElements.set_visible(false)
	UIElements.mouse_filter = Control.MOUSE_FILTER_IGNORE
	await game_starter.start_human_game(2)
	UIElements.set_visible(true)
	UIElements.mouse_filter = Control.MOUSE_FILTER_STOP


func _on_train_request_button_2_pressed() -> void:
	ai_trainer.request_reinforcement()
