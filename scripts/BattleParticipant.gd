class_name BattleParticipant extends Resource

enum CHANGES_TYPES { ADDED = 1, REMOVED = 2 }

var _gold: int
var hand: Dictionary = {}
var card_id_counter: int = 0
var active_cards: Dictionary = {}
var hand_changes: Dictionary = {CHANGES_TYPES.ADDED : [], 
								CHANGES_TYPES.REMOVED : []}
var area_changes: Dictionary = {CHANGES_TYPES.ADDED : [], 
								CHANGES_TYPES.REMOVED : []}
var current_character: int
var score: int

func spend_gold(amount: int):
	_gold -= amount

func add_gold(amount: int):
	_gold += amount

func get_gold() -> int:
	return _gold


func add_card(card_data: CardData):
	hand[card_id_counter] = card_data
	hand_changes[CHANGES_TYPES.ADDED].push_back(card_id_counter)
	card_id_counter += 1


func play_card(card_id: int, card: Card):
	active_cards[card_id] = card
	area_changes[CHANGES_TYPES.ADDED].push_back(card)
	spend_gold(card.cardCost)
	hand.erase(card_id)
