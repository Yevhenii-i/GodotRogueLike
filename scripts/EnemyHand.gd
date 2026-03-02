class_name EnemyHand extends Node

@export var x_pos: int = 0
@export var y_pos: int = 128
@export var hand_width: int = 1200
@export var max_card_distance: int = 150


var hand: Array[Card] = []

@onready var card_scn : PackedScene = preload("res://scenes/Card.tscn")

func add_card():
	var hand_card = card_scn.instantiate()
	hand.push_back(hand_card)
	add_child(hand_card)
	var card_data = CardData.new()
	card_data.name = "Unknown"
	
	hand_card.load_card_data(card_data)
	
	position_cards()

func position_cards():
	var card_spread = min(hand_width / (hand.size() + 1), max_card_distance)
	var current_position = -(card_spread * (hand.size() - 1))/2
	for card in hand :
		_update_card_transform(card, current_position)
		current_position += card_spread

func _update_card_transform(card: Card, current_position: int):
	card.set_position(Vector2(current_position, y_pos))


func remove_card(index: int):
	var removing_card = hand[index]
	hand.remove_at(index)
	remove_child(removing_card)
	position_cards()


func _ready() -> void:
	pass
