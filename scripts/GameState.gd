class_name GameState extends Resource

enum ACTIONS { PLAY_CARD = 1, GET_GOLD = 2, GET_CARD = 3, END_TURN = 10 }

enum CHARACTERS { FIRST = 1, SECOND = 2, THIRD = 3} 

var action_stats: Dictionary = {
	CHARACTERS.FIRST: {
		ACTIONS.PLAY_CARD: 1,
		ACTIONS.GET_GOLD: 2,
		ACTIONS.GET_CARD: 1,
		ACTIONS.END_TURN: 1
	},
	CHARACTERS.SECOND: {
		ACTIONS.PLAY_CARD: 1,
		ACTIONS.GET_GOLD: 4,
		ACTIONS.GET_CARD: 1,
		ACTIONS.END_TURN: 1
	},
	CHARACTERS.THIRD: {
		ACTIONS.PLAY_CARD: 1,
		ACTIONS.GET_GOLD: 2,
		ACTIONS.GET_CARD: 2,
		ACTIONS.END_TURN: 1
	}
}

var turn_order: Array[int] = [
	CHARACTERS.FIRST,
	CHARACTERS.SECOND,
	CHARACTERS.THIRD
]

var deck: Deck
var assigned_characters: Dictionary # character: participant_id

var game_round: int
var surrender: bool = false
var active_character: int = 0
var available_actions: Dictionary #action: amount

var battle_participants_type: Array[int]
var battle_participants: Array[BattleParticipant]

func clear_action_availability():
	available_actions.clear()


func remove_action_availability(action: int):
	available_actions.erase(action)


func reduce_action_availability(action:int, amount:int):
	if not available_actions.has(action):
		return
	
	available_actions[action] -= amount
	
	if available_actions[action] <= 0:
		remove_action_availability(action)


func get_actions_for_character(character: int) -> Dictionary:
	return action_stats[character].duplicate()


func get_participant(participant_id: int) -> BattleParticipant:
	return battle_participants[participant_id]


func update_participant(participant_id: int):
	battle_participants[participant_id].update()
	pass


func set_starting_data(bp1_bonus_gold: int, bp2_bonus_gold: int, bp1_bonus_card: int, 
						bp2_bonus_card : int, deck_removed_cards : int):
	battle_participants[0].add_gold(bp1_bonus_gold)
	battle_participants[1].add_gold(bp2_bonus_gold)
	for i in bp1_bonus_card:
		var runtime_card = deck.get_random_card()
		battle_participants[0].add_card(runtime_card)
	for i in bp2_bonus_card:
		var runtime_card = deck.get_random_card()
		battle_participants[1].add_card(runtime_card)
	for i in deck_removed_cards:
		deck.remove_random_card()
	#print(deck.deck_cards_data.size())


func assign_characters():
	var characters = CHARACTERS.values().duplicate()
	characters.shuffle()
	assigned_characters.clear()
	assigned_characters = {characters[0]: 0, characters[1]: 1}


func get_active_participant_index() -> int:
	return assigned_characters.get(active_character, -1)


func can_play_card(participant_id: int, card_id: int) -> bool:
	if not available_actions.has(ACTIONS.PLAY_CARD):
		return false
	
	var participant = get_participant(participant_id)
	var runtime_card = participant.hand.get(card_id)
	if runtime_card == null:
		return false
	
	return runtime_card.current_cost <= participant.gold


func get_card_data_id(participant_id: int, card_id: int):
	var participant = get_participant(participant_id)
	var runtime_card = participant.hand.get(card_id)
	if runtime_card == null:
		return false
	return runtime_card.data.id


func calculate_scores():
	for participant in battle_participants:
		participant.calculate_score()


func is_game_over() -> bool:
	if surrender:
		return true
	if game_round >= 25:
		return true
	for participant in battle_participants:
		if participant.active_cards.size() == 8:
			return true
	return false


func get_action_str_array(playable_cards: Array) -> Array:
	var actions : Array = []
	if available_actions.has(ACTIONS.PLAY_CARD):
		for card in playable_cards:
			actions.append("play_card_" + str(card["card_id"]))
	if available_actions.has(ACTIONS.GET_GOLD):
		actions.append("get_gold_" + str(available_actions[ACTIONS.GET_GOLD]))
	if available_actions.has(ACTIONS.GET_CARD):
		actions.append("get_card_" + str(available_actions[ACTIONS.GET_CARD]))
	actions.append("end_turn")
	return actions


func get_game_result() -> Dictionary:
	var player_score = battle_participants[0].score
	var enemy_score = battle_participants[1].score
	var winner = 0 
	if (player_score < enemy_score) or surrender:
		winner = 1
	elif player_score == enemy_score:
		winner = 2 #draw
	
	return {
		"final_player_score": player_score,
		"final_enemy_score": enemy_score,
		"winner": winner,
		"total_rounds": game_round
	}


func to_dict(active_index: int) -> Dictionary:
	var self_index = active_index
	var opponent_index = 1 if self_index == 0 else 0
	var cards_for_prediction = self.battle_participants[self_index].get_cards_for_prediction(self.deck.cards_data.size())
	
	return {
		"round": self.game_round,
		"active_character": self.active_character,
		"self_gold": self.battle_participants[self_index].get_gold(),
		"self_score": self.battle_participants[self_index].score,
		"self_hand_size": self.battle_participants[self_index].hand.size(),
		"self_board_size": self.battle_participants[self_index].active_cards.size(),
		"opponent_gold": self.battle_participants[opponent_index].get_gold(),
		"opponent_score": self.battle_participants[opponent_index].score,
		"opponent_hand_size": self.battle_participants[opponent_index].hand.size(),
		"opponent_board_size": self.battle_participants[opponent_index].active_cards.size(),
		"self_active_cards": self.battle_participants[self_index].active_cards.values().map(func(runtime_card): return runtime_card.get_id()),
		"opponent_active_cards": self.battle_participants[opponent_index].active_cards.values().map(func(runtime_card): return runtime_card.get_id()),
		"hand_card_records": cards_for_prediction["card_counts"].duplicate_deep(),
		"unique_hand_card_records": cards_for_prediction["playable_cards"].duplicate_deep() + cards_for_prediction["unplayable_cards"].duplicate_deep(),
		"available_actions": self.get_action_str_array(cards_for_prediction.get("playable_cards")) 
	}
