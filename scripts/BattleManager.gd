class_name BattleManager extends Node

enum ACTIONS { BUILD = 1, GET_GOLD = 2, GET_CARD = 3 }
enum PARTICIPANTS { PLAYER = 1, AI = 2}

@export var battle_participant1_type: int = 1
@export var battle_participant2_type: int = 2

var bp1_manager
var bp2_manager

@onready var battle_screen : String = "res://scenes/BattleScreen.tscn"

var state: GameState

func _ready() -> void:
	state = GameState.new()
	state.battle_participant1 = BattleParticipant.new() 
	state.battle_participant2 = BattleParticipant.new() 
	state.battle_participants = {0: state.battle_participant1, 1: state.battle_participant2}
	state.deck = Deck.new()
	state.deck.create_deck()
	
	if battle_participant1_type == PARTICIPANTS.PLAYER:
		bp1_manager = load(battle_screen).instantiate()
		add_child(bp1_manager)
		bp1_manager.do_action.connect(_on_manager_action)
	else:
		pass
		#set as AIManager
	bp1_manager.update(state)
	
	state.active_character = state.CHARACTERS.FIRST
	
	#create init for second player as AIManager
	
	

func _process(delta: float) -> void:
	if state.active_character == state.CHARACTERS.FIRST:
		state.available_actions = state.action_stats[1]
		
		
		#while !state.available_actions.is_empty():
		bp1_manager.update(state)
		await state_changed()
		
		bp1_manager.update(state)
		await state_changed()


func _on_manager_action(action: GameAction):
	action.execute(state)
	state_changed()


func state_changed():
	pass
