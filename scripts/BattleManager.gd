class_name BattleManager extends Node

signal state_changed()

enum ACTIONS { PLAY_CARD = 1, GET_GOLD = 2, GET_CARD = 3, END_TURN = 10 }
enum PARTICIPANTS { PLAYER = 1, AI = 2}

@export var battle_participant1_type: int = PARTICIPANTS.PLAYER
@export var battle_participant2_type: int = PARTICIPANTS.AI

var managers: Array
var state: GameState

@onready var battle_screen : String = "res://scenes/BattleScreen.tscn"


func _ready() -> void:
	state = GameState.new()
	var battle_participant1 = BattleParticipant.new() 
	var battle_participant2 = BattleParticipant.new() 
	state.battle_participants = [battle_participant1, battle_participant2]
	state.battle_participants_type = [battle_participant1_type, battle_participant2_type]
	state.deck = Deck.new()
	state.deck.create_deck()
	
	managers = []
	
	managers.append(create_manager(battle_participant1_type))
	managers.append(create_manager(battle_participant2_type))

	managers[0].update_state(state) #if manager is UI. Later it is to change 
	
	state.active_character = state.CHARACTERS.FIRST
	
	await run_battle_loop()


func create_manager(type: int):
	if type == PARTICIPANTS.PLAYER:
		var manager = load(battle_screen).instantiate()
		add_child(manager)
		manager.do_action.connect(_on_manager_action)
		return manager
	else:
		var manager = EvaluationAIManager.new()
		add_child(manager)
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
			else:
				print("Character %s skipped." % character)
		state.calculate_scores()
	print(state.game_round)


func run_character_turn(active_index: int):
	while !state.available_actions.is_empty():
		var active_manager = managers[active_index]
		active_manager.update_state(state)
		
		if state.battle_participants_type.has(PARTICIPANTS.PLAYER):
			await state_changed 
		if !state.battle_participants_type[active_index] == PARTICIPANTS.PLAYER and state.battle_participants_type[0] == PARTICIPANTS.PLAYER:
			managers[0].update_graphics(state) #Тимчасово!!!!! замінити це, напевно
		#else:
			
			
		


func _on_manager_action(action: GameAction):
	action.execute(state)
	state_changed.emit()
