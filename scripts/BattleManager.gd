class_name BattleManager extends Node

signal game_ended()
signal state_changed()

enum ACTIONS { PLAY_CARD = 1, GET_GOLD = 2, GET_CARD = 3, END_TURN = 10 }
enum PARTICIPANTS { PLAYER = 1, ALGORYTHM = 2, WEB_AI = 3}

var battle_participant1_type: int
var battle_participant2_type: int

var managers: Array
var state: GameState

var game_logger: GameLogger
var game_history: Array = []
var game_result: Dictionary
var state_snapshot: Dictionary
var game_type: String = "human"

@onready var battle_screen : String = "res://scenes/BattleScreen.tscn"


func _ready() -> void:
	pass

func start_game(bp1_type: int, bp2_type: int, _game_type: String,
				bp1_bonus_gold: int = 0, bp2_bonus_gold: int = 0,
				bp1_bonus_card: int = 0, bp2_bonus_card: int = 0, 
				deck_removed_cards: int = 0):
	self.game_type = _game_type
	state = GameState.new()
	game_logger = GameLogger.new()
	add_child(game_logger)
	battle_participant1_type = bp1_type
	battle_participant2_type = bp2_type
	
	var battle_participant1 = BattleParticipant.new() 
	var battle_participant2 = BattleParticipant.new() 
	state.battle_participants = [battle_participant1, battle_participant2]
	state.battle_participants_type = [battle_participant1_type, battle_participant2_type]
	state.deck = Deck.new()
	state.deck.create_deck()
	
	if !state.battle_participants[0]:
		battle_participant1 = BattleParticipant.new()
		state.battle_participants[0] = battle_participant1
	if !state.battle_participants[1]:
		battle_participant2 = BattleParticipant.new()
		state.battle_participants[1] = battle_participant2
	
	state.set_starting_data(bp1_bonus_gold, bp2_bonus_gold, bp1_bonus_card, bp2_bonus_card, deck_removed_cards)
	
	managers = []
	
	managers.append(create_manager(battle_participant1_type))
	managers.append(create_manager(battle_participant2_type))
	
	managers[0].participant_id = 0
	managers[1].participant_id = 1
	
	if battle_participant1_type == PARTICIPANTS.PLAYER:
		managers[0].update_state(state)
	elif battle_participant2_type == PARTICIPANTS.PLAYER:
		managers[1].update_state(state)
	
	state.active_character = state.CHARACTERS.FIRST
	
	return await run_battle_loop()


func create_manager(type: int):
	if type == PARTICIPANTS.PLAYER:
		var manager = load(battle_screen).instantiate()
		add_child(manager)
		manager.do_action.connect(_on_manager_action)
		manager.end_game.connect(_on_game_ended)
		manager.exit_game.connect(_on_game_exit)
		return manager
	elif type == PARTICIPANTS.ALGORYTHM:
		var manager = AlgorythmManager.new()
		add_child(manager)
		manager.do_action.connect(_on_manager_action)
		return manager
	elif type == PARTICIPANTS.WEB_AI:
		var manager = WebAIManager.new()
		add_child(manager)
		manager.set_game_type(game_type)
		manager.do_action.connect(_on_manager_action)
		return manager


func run_battle_loop():
	while !state.is_game_over():
		state.game_round += 1
		state.assign_characters()
		for character in state.turn_order:
			state.active_character = character
			var active_index = state.get_active_participant_index()
			if active_index != -1:
				state.available_actions = state.get_actions_for_character(character)
				await run_character_turn(active_index)
	game_result = state.get_game_result()
	if !state.surrender:
		game_logger.save_game(game_history, game_result, game_type)
	
	if battle_participant1_type == PARTICIPANTS.PLAYER:
		managers[0].init_end_game(game_result["winner"])
		await managers[0].end_game
	elif battle_participant2_type == PARTICIPANTS.PLAYER:
		managers[1].init_end_game(game_result["winner"])
		await managers[0].end_game
	else:
		game_ended.emit()
	return game_result


func run_character_turn(active_index: int):
	while !state.available_actions.is_empty():
		state_snapshot = state.to_dict(active_index) 
		
		var active_manager = managers[active_index]
		
		await active_manager.update_state(state)
		await active_manager.request_move(state_snapshot)
		
		if state.battle_participants_type[active_index] == PARTICIPANTS.PLAYER:
			await state_changed 
		
		if !state.battle_participants_type[active_index] == PARTICIPANTS.PLAYER and state.battle_participants_type[0] == PARTICIPANTS.PLAYER:
			managers[0].update_graphics(state)
		state.battle_participants[active_index].calculate_score()


func _on_game_ended():
	game_ended.emit()

func _on_game_exit():
	state.surrender = true
	pass


func _on_manager_action(action: GameAction):
	var action_record = action.to_str(state)
	
	if !action.execute(state):
		return
	
	if state_snapshot["available_actions"].size() != 1:
		game_history.append({
			"round": state.game_round,
			"active_actor": action.participant_id,
			"state_before": state_snapshot,
			"action_taken": action_record 
		})
	
	state_changed.emit()
