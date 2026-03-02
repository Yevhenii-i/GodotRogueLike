class_name CardContainer extends Container

const CARD_POSITION: Vector2 = Vector2(74,111)
#@onready var card_scn: PackedScene = preload("res://scenes/Card.tscn")

var card: Card:
	set(_card):
		card = _card
		card.set_position(CARD_POSITION)
		add_child(card)
