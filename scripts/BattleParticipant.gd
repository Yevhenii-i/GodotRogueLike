class_name BattleParticipant extends Resource

enum CHANGES_TYPES { ADDED = 1, REMOVED = 2 }

var gold: int
var hand: Dictionary[int, RuntimeCard] = {} #card_id -> RuntimeCard
var card_id_counter: int = 0

var bonuses: Dictionary = {
	"full_card_types" = 5,
	"full_active_cards" = 7,
	"not_full_card_types" = 0,
	"only_unique_card" = 0
}

var active_card_types: Dictionary = {
	"battle": 0,
	"culture": 0,
	"royal": 0,
	"trade": 0,
	"unique": 0
}
var active_cards: Dictionary[int, RuntimeCard] = {} # card_id -> RuntimeCard
var hand_changes: Dictionary = {CHANGES_TYPES.ADDED : [], 
								CHANGES_TYPES.REMOVED : []}
var area_changes: Dictionary = {CHANGES_TYPES.ADDED : [], 
								CHANGES_TYPES.REMOVED : []}
#var current_character: int
var score: int


func spend_gold(amount: int):
	gold -= amount


func add_gold(amount: int):
	gold += amount


func get_gold() -> int:
	return gold


func get_cards_for_prediction(deck_size: int) -> Dictionary:
	var cards_for_prediction: Dictionary = {
		"playable_cards": [],
		"unplayable_cards": [],
		"card_counts": []
	}
	cards_for_prediction["card_counts"].resize(deck_size)
	cards_for_prediction["card_counts"].fill(0)
	
	var temp_bonuses = bonuses.duplicate_deep()
	
	for card_id in hand.keys():
		var runtime_card = hand.get(card_id)
		
		if cards_for_prediction["card_counts"][runtime_card.data.id] != 0:
			cards_for_prediction["card_counts"][runtime_card.data.id] += 1
			continue
		
		var card_record = {
				"card_id": runtime_card.data.id,
				"current_cost": runtime_card.current_cost,
				"current_value": runtime_card.current_value,
				"potential_value": 0
			}
		
		if runtime_card.data.type == "unique":
			for effect in runtime_card.data.effects.keys():
				temp_bonuses[effect] += runtime_card.data.effects.get(effect)
			
			if active_card_types["unique"] == 1:
				card_record["current_value"] -= bonuses["only_unique_card"]
			elif active_card_types["unique"] == 0:
				card_record["potential_value"] += temp_bonuses["only_unique_card"]
		
		if active_cards.size() == 7:
			card_record["current_value"] += temp_bonuses["full_active_cards"]
		else:
			card_record["potential_value"] += temp_bonuses["full_active_cards"]
		
		var empty_types = active_card_types.values().count(0)
		
		if active_card_types.get(runtime_card.data.type) == 0:
			if empty_types == 1:
				card_record["current_value"] += temp_bonuses["full_card_types"] - temp_bonuses["not_full_card_types"]
			elif empty_types <= 8-active_cards.size():
				card_record["potential_value"] += max(temp_bonuses["full_card_types"], temp_bonuses["not_full_card_types"])
		elif temp_bonuses["full_card_types"] > bonuses["full_card_types"]:
			if empty_types == 0:
				card_record["current_value"] += temp_bonuses["full_card_types"] - bonuses["full_card_types"]
			elif empty_types <= 7-active_cards.size():
				card_record["potential_value"] += max(temp_bonuses["full_card_types"], temp_bonuses["not_full_card_types"])
		else:
			if active_cards.size() < 7:
				card_record["potential_value"] += temp_bonuses["not_full_card_types"]
			else:
				card_record["current_value"] += temp_bonuses["not_full_card_types"]
		
		if runtime_card.data.type == "unique":
			for effect in runtime_card.data.effects.keys():
				temp_bonuses[effect] -= runtime_card.data.effects.get(effect)
		
		if runtime_card.current_cost <= gold:
			cards_for_prediction["playable_cards"].append(card_record)
		else:
			cards_for_prediction["unplayable_cards"].append(card_record)
		cards_for_prediction["card_counts"][runtime_card.data.id]+=1
	
	return cards_for_prediction


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
	hand[card_id_counter] = runtime_card
	hand_changes[CHANGES_TYPES.ADDED].push_back(card_id_counter)
	card_id_counter += 1


func play_card(card_id: int):
	var runtime_card: RuntimeCard = hand[card_id]
	active_cards[card_id] = runtime_card
	active_card_types[runtime_card.data.type] += 1
	hand_changes[CHANGES_TYPES.REMOVED].push_back(card_id)
	area_changes[CHANGES_TYPES.ADDED].push_back(card_id)
	spend_gold(runtime_card.current_cost)
	if !runtime_card.data.effects.is_empty():
		for effect in runtime_card.data.effects.keys():
			bonuses[effect] += runtime_card.data.effects.get(effect)
	hand.erase(card_id)


func calculate_score():
	var card_value = 0
	for runtime_card in active_cards.values():
		card_value += runtime_card.current_value
	
	var bonus_value = 0
	if active_cards.size() == 8:
		bonus_value += bonuses["full_active_cards"]
	
	if !active_card_types.values().has(0):
		bonus_value += bonuses["full_card_types"]
	else:
		bonus_value += bonuses["not_full_card_types"]
	
	if active_card_types.get("unique") == 1:
		bonus_value += bonuses["only_unique_card"]
	
	score = card_value + bonus_value
