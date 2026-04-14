class_name CardContainer extends Container

const CARD_POSITION: Vector2 = Vector2(74,111)
@onready var card_scn: PackedScene = preload("res://scenes/Card.tscn")

var card_id: int
var runtime_card: RuntimeCard #var card_data: CardData
var card_node: Card

func setup(_card_id: int, _runtime_card: RuntimeCard): #_card_data: CardData):
	card_id = _card_id
	runtime_card = _runtime_card #card_data = _card_data

func _ready():
	_create_card()

func _create_card():
	card_node = card_scn.instantiate()
	card_node.setup(card_id, runtime_card) #card_data)
	add_child(card_node)
	card_node.position = CARD_POSITION
