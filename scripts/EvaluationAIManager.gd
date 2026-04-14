class_name EvaluationAIManager extends Node

enum ACTIONS { PLAY_CARD = 1, GET_GOLD = 2, GET_CARD = 3, END_TURN = 10 }

signal do_action(action: GameAction)


var participant_id: int = 1
var available_actions: Dictionary = {}

func update_state(state: GameState):
	available_actions = state.available_actions
	if state.battle_participants_type.has(1):
		await get_tree().create_timer(1.0).timeout

	
	var participant = state.battle_participants[participant_id]
	
	if state.active_character == state.CHARACTERS.FIRST:
		if participant.get_gold() > participant.hand.size()*3 and available_actions.has(ACTIONS.GET_CARD):
			get_card_action()
			return
		elif available_actions.has(ACTIONS.GET_GOLD):
			get_gold_action()
			return
	
	if state.active_character == state.CHARACTERS.SECOND:
		if participant.get_gold() < 8 and available_actions.has(ACTIONS.GET_GOLD):
			get_gold_action()
			return
		elif available_actions.has(ACTIONS.GET_CARD):
			get_card_action()
			return
		
	
	if state.active_character == state.CHARACTERS.THIRD:
		if participant.hand.size() > 5 and available_actions.has(ACTIONS.GET_CARD):
			get_card_action()
			return
		elif available_actions.has(ACTIONS.GET_GOLD):
			get_gold_action()
			return
	
	
	if !participant.hand.is_empty():
		for card_id in participant.hand.keys():
			if !available_actions.has(ACTIONS.PLAY_CARD):
				continue
			if state.can_play_card(participant_id, card_id):
				activate_card_action(card_id)
				return
	
	end_turn_action()
	return



func activate_card_action(card_id: int) -> void:
	var action = PlayCardAction.new()
	action.participant_id = participant_id
	action.card_id = card_id
	do_action.emit(action)


func get_card_action() -> void:
	var action = GetCardsAction.new()
	action.participant_id = participant_id
	action.cards_amount = available_actions.get(ACTIONS.GET_CARD)
	do_action.emit(action)


func get_gold_action() -> void:
	var action = GetGoldAction.new()
	action.participant_id = participant_id
	action.gold_amount = available_actions.get(ACTIONS.GET_GOLD)
	do_action.emit(action)


func end_turn_action() -> void:
	var action = EndTurnAction.new()
	action.participant_id = participant_id
	do_action.emit(action)
