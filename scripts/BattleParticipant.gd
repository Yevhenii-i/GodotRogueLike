class_name BattleParticipant extends Resource

enum CHANGES_TYPES { ADDED = 1, REMOVED = 2 }

var gold: int
var hand: Dictionary = {} #card_id -> RuntimeCard
var card_id_counter: int = 0

var active_card_types: Dictionary = {
	"battle": 0,
	"culture": 0,
	"royal": 0,
	"trade": 0,
	"unique": 0
}
var active_cards: Dictionary = {} # card_id -> RuntimeCard
var hand_changes: Dictionary = {CHANGES_TYPES.ADDED : [], 
								CHANGES_TYPES.REMOVED : []}
var area_changes: Dictionary = {CHANGES_TYPES.ADDED : [], 
								CHANGES_TYPES.REMOVED : []}
var current_character: int
var score: int

func spend_gold(amount: int):
	gold -= amount

func add_gold(amount: int):
	gold += amount

func get_gold() -> int:
	return gold


func update():
	#updates hand cards (their cost) according to active effects
	pass


func consume_hand_changes() -> Dictionary:
	var changes = hand_changes.duplicate(true)
	hand_changes[CHANGES_TYPES.ADDED].clear()
	hand_changes[CHANGES_TYPES.REMOVED].clear()
	return changes


func consume_area_changes() -> Dictionary:
	var changes = area_changes.duplicate(true)
	area_changes[CHANGES_TYPES.ADDED].clear()
	area_changes[CHANGES_TYPES.REMOVED].clear()
	return changes


func add_card(runtime_card: RuntimeCard):
	hand[card_id_counter] = runtime_card ### I JUST ADDED IT INSTEAAD OF CARD_DATA. ADJUST THE REST OF THE APP!!!
	hand_changes[CHANGES_TYPES.ADDED].push_back(card_id_counter)
	card_id_counter += 1


func play_card(card_id: int):
	var runtime_card = hand[card_id] #var card_data = hand[card_id]
	active_cards[card_id] = runtime_card #card_data
	active_card_types[runtime_card.data.type] += 1
	hand_changes[CHANGES_TYPES.REMOVED].push_back(card_id)
	area_changes[CHANGES_TYPES.ADDED].push_back(card_id)
	spend_gold(runtime_card.current_cost) #spend_gold(card_data.cost)
	hand.erase(card_id)


func calculate_score():
	var card_value = 0
	for runtime_card in active_cards.values():
		card_value += runtime_card.current_value
	
	var bonus_value = 0
	if active_cards.size() == 8:
		bonus_value += 7
	
	var type_prod = 1
	for type in active_card_types.values():
		type_prod *= type
	
	if type_prod !=0:
		bonus_value += 5
	
	score = card_value + bonus_value
	
	pass
