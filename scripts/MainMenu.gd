class_name MainMenu extends Node

var api_communicator: APICommunicator

#@onready var mainGameScene : PackedScene = preload("res://scenes/MainGame.tscn")
@onready var mainGame : String = "res://scenes/MainGame.tscn"
@onready var UIElements = $"UI Elements"

var main_game_scene : PackedScene
var main_game_instance : Node

func _ready() -> void:
	api_communicator = APICommunicator.new()
	add_child(api_communicator)


func _on_upload_button_pressed() -> void:
	api_communicator.start_sync_process() #upload_all_game_data("res://game_saves/not_uploaded/")



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
	await main_game_instance.start_game(1, 3)
	
	get_tree().root.remove_child(main_game_instance)
	main_game_instance.queue_free()
	UIElements.set_visible(true)
	UIElements.mouse_filter = Control.MOUSE_FILTER_STOP



func _on_simulate_button_pressed() -> void:
	main_game_scene = load(mainGame)
	
	for i in range(1000):
		main_game_instance = main_game_scene.instantiate()
		get_tree().root.add_child(main_game_instance)
		#get_tree().change_scene_to_node(main_game_instance)
		await main_game_instance.start_game(2, 2)
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
