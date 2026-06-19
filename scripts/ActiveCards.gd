class_name ActiveCards extends Node2D

@onready var card_container_scn: PackedScene = preload("res://scenes/СardСontainer.tscn")
@onready var cardArea = $CardArea

var active_cards: Dictionary = {} # card_id : runtime_card

func clear_area():
	for child in cardArea.get_children():
		child.remove_child(child.card_node)
		cardArea.remove_child(child)
		child.card_node.queue_free()
		child.queue_free()


func refresh_area():
	clear_area()
	for card_id in active_cards.keys():
		var runtime_card = active_cards[card_id]
		var card_container: CardContainer = card_container_scn.instantiate() as CardContainer
		card_container.setup(card_id, runtime_card)
		cardArea.add_child(card_container)


func add_card(card_id: int, runtime_card: RuntimeCard):
	active_cards[card_id] = runtime_card
	refresh_area()


func remove_card(card_id: int):
	if not active_cards.has(card_id):
		return
	active_cards.erase(card_id)
	refresh_area()
