@tool
extends Node2D

signal card_activate(card: Card)

@export var x_pos: int = 0
@export var y_pos: int = -128
@export var hand_width: int = 1200
@export var max_card_distance: int = 150


@onready var card_scn : PackedScene = preload("res://scenes/Card.tscn")


var hand: Dictionary = {}
var hand_by_node: Dictionary = {}
var hovered: Array
var current_selected_card_index: int = -1

func add_card(card_id: int, card_data: CardData):
	var hand_card = card_scn.instantiate()
	hand[card_id] = hand_card
	hand_by_node[hand_card] = card_id
	add_child(hand_card)
	hand_card.mouse_entered.connect(_handle_card_hover)
	hand_card.mouse_exited.connect(_handle_card_unhover)
	
	hand_card.load_card_data(card_data)
	position_cards()


func _handle_card_hover(card):
	print("touch")
	hovered.push_back(card)


func _handle_card_unhover(card):
	print("no touch")
	hovered.remove_at(hovered.find(card))


func position_cards():
	var card_spread = min(hand_width / (hand.size() + 1), max_card_distance)
	var current_position = -(card_spread * (hand.size() - 1))/2
	for card in hand.values():
		_update_card_transform(card, current_position)
		current_position += card_spread

func _update_card_transform(card: Card, current_position: int):
	card.set_position(Vector2(current_position, y_pos))


func remove_card(index: int):# -> Node2D:
	var removing_card = hand[index]
	removing_card.mouse_entered.disconnect(_handle_card_hover)
	removing_card.mouse_exited.disconnect(_handle_card_unhover)
	hand.erase(index)
	hand_by_node.erase(removing_card)
	hovered.remove_at(hovered.find(removing_card))
	remove_child(removing_card)
	position_cards()
#	return removing_card


func remove_card_by_entity(card: Card):
	var remove_index = hand.find_key(card)
	remove_card(remove_index)


func _input(event):
	if event.is_action_pressed("mouse_click") && current_selected_card_index >= 0:
		var card = hand[current_selected_card_index]
		remove_card_by_entity(card)
		
		#card.queue_free()
		card.unhighlight()
		card_activate.emit(card)
		current_selected_card_index = -1


func _ready() -> void:
	pass


func _process(delta: float) -> void:
	for card in hand.values():
		current_selected_card_index = -1
		card.unhighlight()

	if !hovered.is_empty():
		var highest_hovered_index: int = -1
		
		for hovered_card in hovered:
			var index = hand_by_node.get(hovered_card, -1)
			highest_hovered_index = max(highest_hovered_index, index)


		if highest_hovered_index >= 0 && highest_hovered_index < hand.size():
			hand[highest_hovered_index].highlight()
			current_selected_card_index = highest_hovered_index
