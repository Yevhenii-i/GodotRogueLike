@tool
class_name Card extends Node2D

signal mouse_entered(card_id: int)
signal mouse_exited(card_id: int)


@onready var costLabel: Label = $CostBar/CostLabel
@onready var nameLabel: Label = $CardDescription/CardNameLabel
@onready var additLabel: Label = $CardDescription/CardAdditLabel
@onready var imageSprite: Sprite2D = $CardImageSprite
@onready var typeSprite: Sprite2D = $CardTypeSprite
@onready var baseSprite: Sprite2D = $CardBaseSprite

var card_id: int
var runtime_card: RuntimeCard

var is_playable: bool = false


func setup(_card_id: int, _runtime_card: RuntimeCard):
	card_id = _card_id
	runtime_card = _runtime_card

func _ready() -> void:
	_update_graphics()

func _update_graphics():
	costLabel.set_text(str(runtime_card.current_cost))
	nameLabel.set_text(runtime_card.data.name)
	additLabel.set_text(runtime_card.data.additionalInfo)
	imageSprite.set_texture(load("res://sprites/card_images/"+ runtime_card.data.textureName +".png"))
	typeSprite.set_texture(load("res://sprites/types/"+ runtime_card.data.type +"_type.png"))


func set_playable(value: bool):
	is_playable = value
	modulate =  Color(1,1,1) if value else Color(0.5,0.5,0.5)


func highlight():
	baseSprite.set_modulate(Color(0.553, 0.629, 1.0, 1.0))
	set_scale(Vector2(1.5, 1.5))


func unhighlight():
	baseSprite.set_modulate(Color(1,1,1,1))
	set_scale(Vector2(1.0, 1.0))


func _on_area_2d_mouse_entered():
	mouse_entered.emit(card_id)


func _on_area_2d_mouse_exited():
	mouse_exited.emit(card_id)
