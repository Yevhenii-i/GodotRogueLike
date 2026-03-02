class_name Deck extends RefCounted

var deck_cards_data: Dictionary = {}
var card_id = 0
@export var cards_data: Array[CardData] = [load("res://data_objects/cards/barracs_card.tres"), 
load("res://data_objects/cards/belltower_card.tres"), 
load("res://data_objects/cards/dark_tower_card.tres"), 
load("res://data_objects/cards/tavern_card.tres"), 
load("res://data_objects/cards/trading_house_card.tres")]

func create_deck():
	for i in cards_data:
		var card_instance = i.duplicate(true)
		add_card(card_instance)

func add_card(card_data: CardData):
	card_id += 1
	deck_cards_data[card_id] = card_data

func get_random_card() -> CardData:
	var random_key = deck_cards_data.keys().pick_random()
	return deck_cards_data[random_key]


func remove_card():
	pass
