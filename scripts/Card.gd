@tool
class_name Card extends Node2D

signal mouse_entered(card: Card)
signal mouse_exited(card: Card)

@export var cardName: String = "Name"
@export var cardAdditionalInfo: String = "Additional info"
@export var cardCost: int = 1
@export var cardType: String = "unique"
@export var cardImageName: String = "Camp"

@onready var costLabel: Label = $CostBar/CostLabel
@onready var nameLabel: Label = $CardDescription/CardNameLabel
@onready var additLabel: Label = $CardDescription/CardAdditLabel
@onready var imageSprite: Sprite2D = $CardImageSprite
@onready var typeSprite: Sprite2D = $CardTypeSprite
@onready var baseSprite: Sprite2D = $CardBaseSprite

func _ready() -> void:
	set_card_values(cardCost, cardName, cardAdditionalInfo, cardImageName, cardType)


func set_card_values(_cost: int, _name: String, _additionalInfo: String, _imageName: String, _type: String):
	cardCost = _cost
	cardName = _name
	cardAdditionalInfo = _additionalInfo
	cardImageName = _imageName
	cardType = _type
	_update_graphics()


func load_card_data(card_data: CardData):
	set_card_values(card_data.cost, card_data.name, card_data.additionalInfo, card_data.textureName, card_data.type)
	imageSprite.set_texture(load("res://sprites/card_images/"+ cardImageName +".png"))
	typeSprite.set_texture(load("res://sprites/types/"+ cardType +"_type.png"))
	#for script in card_data.actions:
	#	var action_script = RefCounted.new()
	#	action_script.set_script(script)
	#	actions.push_back(action_script)


func _update_graphics():
	if costLabel.get_text() != str(cardCost):
		costLabel.set_text(str(cardCost))
	if nameLabel.get_text() != cardName:
		nameLabel.set_text(cardName)
	if additLabel.get_text() != cardAdditionalInfo:
		additLabel.set_text(cardAdditionalInfo)
	
func _process(delta: float) -> void:
	pass


func highlight():
	baseSprite.set_modulate(Color(0.553, 0.629, 1.0, 1.0))
	set_scale(Vector2(1.5, 1.5))


func unhighlight():
	baseSprite.set_modulate(Color(1,1,1,1))
	set_scale(Vector2(1.0, 1.0))


func _on_area_2d_mouse_entered():
	mouse_entered.emit(self)


func _on_area_2d_mouse_exited():
	mouse_exited.emit(self)


func _on_area_2d_input_event(viewport: Node, event: InputEvent, shape_idx: int) -> void:
	pass # Replace with function body.
