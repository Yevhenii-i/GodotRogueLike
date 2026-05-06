class_name AlgorythmManager extends Node

enum ACTIONS { PLAY_CARD = 1, GET_GOLD = 2, GET_CARD = 3, END_TURN = 10 }

signal do_action(action: GameAction)


var participant_id: int = 1
var available_actions: Dictionary = {}
var participant: BattleParticipant

func update_state(state: GameState):
	available_actions = state.available_actions
	if state.battle_participants_type.has(1):
		await get_tree().create_timer(1.0).timeout

	
	participant = state.battle_participants[participant_id]
	
	if state.active_character == state.CHARACTERS.FIRST:
		if participant.get_gold() > participant.hand.size()*3 and available_actions.has(ACTIONS.GET_CARD):
			get_card_action()
			return
		elif available_actions.has(ACTIONS.GET_GOLD):
			get_gold_action()
			return
	
	if state.active_character == state.CHARACTERS.SECOND:
		if (participant.get_gold() < 8 or participant.get_gold() <= 2*participant.hand.size()) and available_actions.has(ACTIONS.GET_GOLD):
			get_gold_action()
			return
		elif available_actions.has(ACTIONS.GET_CARD):
			get_card_action()
			return
		
	
	if state.active_character == state.CHARACTERS.THIRD:
		if (participant.hand.size() < 5 or participant.get_gold() >= 2*participant.hand.size()) and available_actions.has(ACTIONS.GET_CARD):
			get_card_action()
			return
		elif available_actions.has(ACTIONS.GET_GOLD):
			get_gold_action()
			return
	
	
	if !participant.hand.is_empty():
		if available_actions.has(ACTIONS.PLAY_CARD):
			var evaluated_cards = participant.get_cards_for_prediction(11)
			var unique_cards = evaluated_cards["playable_cards"] + evaluated_cards["unplayable_cards"]
			
			var card_to_play = [-999, 999, -999]
			
			for card in unique_cards:
				var summary_value = card["current_value"]+card["potential_value"]
				if card["current_value"] > 0:
					if summary_value > card_to_play[2]:
						card_to_play = [card["card_id"], card["current_cost"], summary_value]
					elif summary_value == card_to_play[2] and card["current_cost"] < card_to_play[1]:
						card_to_play = [card["card_id"], card["current_cost"], summary_value]
			
			if evaluated_cards["playable_cards"].map(func(card_record): return card_record["card_id"]).has(card_to_play[0]):
				var hand_card_values_id = participant.hand.values().find_custom(func(runtime_card): return runtime_card.get_id() == card_to_play[0])
				
				if hand_card_values_id != null:
					var hand_card_id = participant.hand.find_key(participant.hand.values()[hand_card_values_id])
					activate_card_action(hand_card_id)
					return
				
			
			#for card_id in participant.hand.keys():
			#	if state.can_play_card(participant_id, card_id):
			#		activate_card_action(card_id)
			#		return
	
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
