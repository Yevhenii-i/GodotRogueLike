@tool
extends Node2D

signal card_activate(card_id: int)

@export var x_pos: int = 0
@export var y_pos: int = -128
@export var hand_width: int = 1200
@export var max_card_distance: int = 150

@onready var card_scn : PackedScene = preload("res://scenes/Card.tscn")

var hand: Dictionary = {} # card_id -> Card
var hovered_ids: Array = []
var current_selected_card_id: int = -1

func add_card(card_id: int, runtime_card: RuntimeCard): # card_data: CardData):
	var card_node = card_scn.instantiate()
	card_node.setup(card_id, runtime_card) #card_data)
	
	hand[card_id] = card_node
	add_child(card_node)
	card_node.mouse_entered.connect(_handle_card_hover)
	card_node.mouse_exited.connect(_handle_card_unhover)

	position_cards()


func _handle_card_hover(card_id: int):
	print(hand[card_id].is_playable)
	hovered_ids.push_back(card_id)


func _handle_card_unhover(card_id: int):
	print("no touch")
	hovered_ids.erase(card_id)


func position_cards():
	var card_spread = min(hand_width / (hand.size() + 1), max_card_distance)
	var current_position = -(card_spread * (hand.size() - 1))/2
	
	for card_id in hand.keys():
		var card = hand[card_id]
		card.set_position(Vector2(current_position, y_pos))
		current_position += card_spread


func remove_card(card_id: int):# -> Node2D:
	if not hand.has(card_id):
		return
	
	var card = hand[card_id]
	
	hand.erase(card_id)
	hovered_ids.erase(card_id)
	remove_child(card)
	card.queue_free()
	
	position_cards()


func _input(event):
	if event.is_action_pressed("mouse_click") && current_selected_card_id >= 0:
		card_activate.emit(current_selected_card_id)


func _ready() -> void:
	pass


func _process(delta: float) -> void:
	current_selected_card_id = -1
	
	for card in hand.values():
		card.unhighlight()

	if hovered_ids.is_empty():
		return
	
	var highest_hovered_id: int = hovered_ids.max()
	
	if hand.has(highest_hovered_id):
		hand[highest_hovered_id].highlight()
		current_selected_card_id = highest_hovered_id
