class_name ActiveCards extends Node2D


@onready var card_container_scn: PackedScene = preload("res://scenes/СardСontainer.tscn")
@onready var card_area = $CardArea

var active_cards: Dictionary = {} # card_id : runtime_card  # card_id : card_data

func clear_display():
	for child in card_area.get_children():
		child.remove_child(child.card_node)
		card_area.remove_child(child)
		child.card_node.queue_free()
		child.queue_free()


func refresh_display():
	clear_display()
	
	for card_id in active_cards.keys():
		var runtime_card = active_cards[card_id] # var card_data = active_cards[card_id]
		
		var card_container: CardContainer = card_container_scn.instantiate() as CardContainer
		
		card_container.setup(card_id, runtime_card) #card_data)
		card_area.add_child(card_container)


func add_card(card_id: int, runtime_card: RuntimeCard): # card_data: CardData):
	active_cards[card_id] = runtime_card #card_data
	refresh_display()


func remove_card(card_id: int):
	if not active_cards.has(card_id):
		return
	
	active_cards.erase(card_id)
	
	refresh_display()
