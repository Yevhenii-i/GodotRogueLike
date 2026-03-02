class_name GameState extends Resource

enum ACTIONS { BUILD = 1, GET_GOLD = 2, GET_CARD = 3 }

enum CHARACTERS { FIRST = 1, SECOND = 2, THIRD = 3} #, FOURTH = 4, FIFTH = 5, SIXTH = 6}

var action_stats: Dictionary = {
	CHARACTERS.FIRST: {
		ACTIONS.BUILD: 1,
		ACTIONS.GET_GOLD: 2,
		ACTIONS.GET_CARD: 1,
	},
	CHARACTERS.SECOND: {
		ACTIONS.BUILD: 1,
		ACTIONS.GET_GOLD: 4,
		ACTIONS.GET_CARD: 1,
	},
	CHARACTERS.THIRD: {
		ACTIONS.BUILD: 1,
		ACTIONS.GET_GOLD: 2,
		ACTIONS.GET_CARD: 2,
	}
}

var deck: Deck
var characters: Array


var round: int
var active_character: int
var available_actions: Dictionary


var battle_participant1: BattleParticipant
var battle_participant2: BattleParticipant
var battle_participants: Dictionary



func remove_action_availability(action: int):
	available_actions.erase(action)


func get_participant(id: int) -> BattleParticipant:
	return battle_participants[id]
