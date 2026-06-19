class_name GameStarter extends Node

@onready var mainGame : String = "res://scenes/MainGame.tscn"

var main_game_scene : PackedScene
var main_game_instance : Node

func start_human_game(bp2_type: int):
	var game_result: Dictionary
	var bonus_gold: int
	
	game_result = await start_game(1, bp2_type, "human", 0, 0, 0, 0, 0)
	if game_result["winner"] == 0: 
		bonus_gold = min(int((game_result["final_player_score"] - game_result["final_enemy_score"]) / 2), 5)
		game_result = await start_game(1, bp2_type, "human", bonus_gold, 5, 0, 1, 1)
	if game_result["winner"] == 0: 
		bonus_gold = min(int(game_result["final_player_score"] - game_result["final_enemy_score"] / 2), 7)
		game_result = await start_game(1, bp2_type, "human", bonus_gold, 10, 0, 2, 3)


func start_simulation_games(amount: int, type: String):

	if type == "training":
		for i in range(amount):
			await start_game(2, 2, "training")
	elif type == "reinforcement":
		for i in range(amount):
			await start_game(3, 3, "reinforcement")


func start_game(bp1_type: int, bp2_type: int, game_type: String,
				bp1_bonus_gold: int = 0, bp2_bonus_gold: int = 0,
				bp1_bonus_card: int = 0, bp2_bonus_card: int = 0, 
				deck_removed_cards: int = 0):
	var game_result: Dictionary
	main_game_scene = load(mainGame)
	main_game_instance = main_game_scene.instantiate()
	
	get_tree().root.add_child(main_game_instance)
	#get_tree().change_scene_to_node(main_game_instance)
	
	game_result = await main_game_instance.start_game(bp1_type, bp2_type, game_type, bp1_bonus_gold, bp2_bonus_gold, bp1_bonus_card, bp2_bonus_card, deck_removed_cards)
	game_result.duplicate(true)
	
	get_tree().root.remove_child(main_game_instance)
	main_game_instance.queue_free()
	return game_result
