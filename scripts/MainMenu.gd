class_name MainMenu extends Node

var game_uploader: GameUploader
var ai_trainer: AITrainer

#@onready var mainGameScene : PackedScene = preload("res://scenes/MainGame.tscn")
@onready var mainGame : String = "res://scenes/MainGame.tscn"
@onready var UIElements = $"UI Elements"

var main_game_scene : PackedScene
var main_game_instance : Node


func _ready() -> void:
	game_uploader = GameUploader.new()
	add_child(game_uploader)
	ai_trainer = AITrainer.new()
	add_child(ai_trainer)


func _on_upload_button_pressed() -> void:
	game_uploader.start_sync_process() #upload_all_game_data("res://game_saves/not_uploaded/")


func _on_play_button_pressed() -> void:
	#var main_game_instance = mainGameScene.instantiate()
	main_game_scene = load(mainGame)
	main_game_instance = main_game_scene.instantiate()
	
	UIElements.set_visible(false)
	UIElements.mouse_filter = Control.MOUSE_FILTER_IGNORE
	#UIElements.set_process(false)
	#UIElements.set_process_input(false)
	#add_child(main_game_instance)
	
	get_tree().root.add_child(main_game_instance)
	get_tree().change_scene_to_node(main_game_instance)
	
	#main_game_instance.game_ended.connect(_on_game_ended)
	await main_game_instance.start_game(1, 3, "human")
	
	get_tree().root.remove_child(main_game_instance)
	main_game_instance.queue_free()
	UIElements.set_visible(true)
	UIElements.mouse_filter = Control.MOUSE_FILTER_STOP


func _on_training_button_pressed() -> void:
	main_game_scene = load(mainGame)
	
	for i in range(1000):
		main_game_instance = main_game_scene.instantiate()
		get_tree().root.add_child(main_game_instance)
		#get_tree().change_scene_to_node(main_game_instance)
		await main_game_instance.start_game(2, 2, "training")
		get_tree().root.remove_child(main_game_instance)
		main_game_instance.queue_free()


func _on_reinforce_button_pressed() -> void:
	main_game_scene = load(mainGame)
	
	for i in range(1000):
		main_game_instance = main_game_scene.instantiate()
		get_tree().root.add_child(main_game_instance)
		#get_tree().change_scene_to_node(main_game_instance)
		await main_game_instance.start_game(3, 3, "reinforcement")
		get_tree().root.remove_child(main_game_instance)
		main_game_instance.queue_free()


func _on_game_ended() -> void:
	if main_game_instance:
		get_tree().root.remove_child(main_game_instance)
		main_game_instance.queue_free()
	UIElements.set_visible(true)
	UIElements.mouse_filter = Control.MOUSE_FILTER_STOP
	pass




func _on_mouse_entered() -> void:
	print("MainMenu got input")
	pass # Replace with function body.


func _on_train_request_button_pressed() -> void:
	ai_trainer.request_training()


func _on_play_button_2_pressed() -> void:
	main_game_scene = load(mainGame)
	main_game_instance = main_game_scene.instantiate()
	
	UIElements.set_visible(false)
	UIElements.mouse_filter = Control.MOUSE_FILTER_IGNORE
	
	get_tree().root.add_child(main_game_instance)
	get_tree().change_scene_to_node(main_game_instance)
	
	await main_game_instance.start_game(1, 2, "human")
	
	get_tree().root.remove_child(main_game_instance)
	main_game_instance.queue_free()
	UIElements.set_visible(true)
	UIElements.mouse_filter = Control.MOUSE_FILTER_STOP


func _on_train_request_button_2_pressed() -> void:
	ai_trainer.request_reinforcement()
