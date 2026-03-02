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

var deck: Deck
var assigned_characters: Array


var round: int
var active_character: int = 0
var available_actions: Dictionary


var battle_participant1: BattleParticipant
var battle_participant2: BattleParticipant
var battle_participants: Dictionary


func clear_action_availability():
	available_actions.clear()


func remove_action_availability(action: int):
	available_actions.erase(action)

func reduce_action_availability(action:int, amount:int):
	available_actions[action] -= amount
	if available_actions[action] == 0:
		remove_action_availability(action)


func get_participant(id: int) -> BattleParticipant:
	return battle_participants[id]
