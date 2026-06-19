class_name Deck extends RefCounted

var deck_cards_data: Dictionary = {}
var card_id = 0
@export var cards_data: Array[CardData] = [load("res://data_objects/cards/barracs_card.tres"), 
load("res://data_objects/cards/belltower_card.tres"), 
load("res://data_objects/cards/tavern_card.tres"), 
load("res://data_objects/cards/trading_house_card.tres"),
load("res://data_objects/cards/training_camp.tres"),
load("res://data_objects/cards/mine.tres"),
load("res://data_objects/cards/castle_wall.tres"),
load("res://data_objects/cards/watch_tower.tres"),
load("res://data_objects/cards/dark_tower_card.tres"),
load("res://data_objects/cards/ominous_building.tres"),
load("res://data_objects/cards/strange_castle.tres")]

func create_deck():
	for i in cards_data:
		var card_instance = i.duplicate(true)
		add_card(card_instance)

func add_card(card_data: CardData):
	card_id += 1
	deck_cards_data[card_id] = card_data

func get_random_card() -> RuntimeCard:
	var random_key = deck_cards_data.keys().pick_random()
	var runtime_card = RuntimeCard.new()
	runtime_card.data = deck_cards_data[random_key]
	runtime_card.current_cost = runtime_card.data.cost
	runtime_card.current_value = runtime_card.data.cost
	return runtime_card


func remove_random_card():
	var random_key = deck_cards_data.keys().pick_random()
	remove_card(random_key)


func remove_card(id: int):
	deck_cards_data.erase(id)
