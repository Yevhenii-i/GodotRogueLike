class_name GameState extends Resource

enum ACTIONS { PLAY_CARD = 1, GET_GOLD = 2, GET_CARD = 3, END_TURN = 10 }

enum CHARACTERS { FIRST = 1, SECOND = 2, THIRD = 3} #, FOURTH = 4, FIFTH = 5, SIXTH = 6}

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
	var runtime_card = participant.hand.get(card_id) #var card_data = participant.hand.get(card_id)
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
	if game_round >= 25:
		return true
	for participant in battle_participants:
		if participant.active_cards.size() == 8:
			return true
	return false


func to_dict(active_index: int):
	return {
		"round": self.game_round,
		"active_character": self.active_character,
		"actions_remaining": self.available_actions.size(), #replace with a function to return actual number
		"self_gold": self.battle_participants[active_index].get_gold(),
		"self_score": self.battle_participants[active_index].score,
		"self_hand_size": self.battle_participants[active_index].hand.size(),
		"self_board_count": self.battle_participants[active_index].active_cards.size(),
		"opponent_score": self.battle_participants[1 - active_index].score,
		"opponent_hand_size": self.battle_participants[1 - active_index].hand.size(),
		"opponent_board_count": self.battle_participants[1 - active_index].active_cards.size(),
		"playable_hand_cards": [], #replace with a function
		"available_actions": self.available_actions.duplicate(true)
	}
