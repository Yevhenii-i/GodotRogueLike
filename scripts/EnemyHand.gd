class_name EnemyHand extends Node

@export var x_pos: int = 0
@export var y_pos: int = 128
@export var hand_width: int = 1200
@export var max_card_distance: int = 150


var hand: Array[Card] = []

@onready var card_scn : PackedScene = preload("res://scenes/Card.tscn")

func add_card():
	var card_node = card_scn.instantiate()
	
	var card_data = CardData.new()
	
	card_data.name = "Unknown"
	card_data.cost = 0
	card_data.additionalInfo = ""
	card_data.textureName = ""
	card_data.type = ""
	var runtime_card = RuntimeCard.new()
	runtime_card.data = card_data
	runtime_card.current_cost = 0
	runtime_card.current_value = 0
	card_node.setup(0, runtime_card)
	
	hand.push_back(card_node)
	add_child(card_node)
	
	position_cards()

func position_cards():
	var card_spread = min(hand_width / (hand.size() + 1), max_card_distance)
	var current_position = -(card_spread * (hand.size() - 1))/2
	for card in hand :
		card.set_position(Vector2(current_position, y_pos)) #_update_card_transform(card, current_position)
		current_position += card_spread

#func _update_card_transform(card: Card, current_position: int):
#	card.set_position(Vector2(current_position, y_pos))


func remove_card():
	var removing_card = hand[-1]
	hand.remove_at(-1)
	remove_child(removing_card)
	position_cards()


func _ready() -> void:
	pass
