class_name ActiveCards extends Node2D


@onready var card_container_scn: PackedScene = preload("res://scenes/СardСontainer.tscn")
@onready var card_area = $CardArea

var active_cards: Array = []

func clear_display():
	for child in card_area.get_children():
		child.remove_child(child.card)
		card_area.remove_child(child)

func add_card(added_card: Card):
	clear_display()
	active_cards.push_back(added_card)
	
	for card in active_cards:
		var card_container: CardContainer = card_container_scn.instantiate() as CardContainer
		card_container.card = card
		card_area.add_child(card_container)


func remove_card():
	pass
