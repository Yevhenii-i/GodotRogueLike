class_name BattleParticipant extends Resource

enum HAND_CHANGES_TYPES { ADDED = 1, REMOVED = 2 }

var _gold: int
var hand: Dictionary = {}
var card_id_counter: int = 0
var active_cards: Array[CardData]
var hand_changes: Dictionary = {HAND_CHANGES_TYPES.ADDED : [], 
								HAND_CHANGES_TYPES.REMOVED : []}
var current_character: int
var score: int

func spend_gold(amount: int):
	_gold -= amount

func add_gold(amount: int):
	_gold += amount

func get_gold() -> int:
	return _gold

func add_card(card_data):
	hand[card_id_counter] = (card_data)
	hand_changes[HAND_CHANGES_TYPES.ADDED].push_back(card_id_counter)
	card_id_counter += 1

func enough_gold(cost: int) -> bool:
	if (_gold>=cost):
		return true
	else:
		return false
