class_name RuntimeCard extends RefCounted


var data: CardData
var current_cost: int
var current_value: int

func get_id() -> int:
	return self.data.id
