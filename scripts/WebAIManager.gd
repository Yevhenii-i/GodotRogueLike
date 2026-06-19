class_name WebAIManager extends Node

enum ACTIONS { PLAY_CARD = 1, GET_GOLD = 2, GET_CARD = 3, END_TURN = 10 }

signal do_action(action: GameAction)
signal action_set()

var http_request: HTTPRequest
var url: String = "https://gamewebai.onrender.com/ai/move"

const NUM_UNIQUE_CARDS = 11

var action_map : Dictionary = {
	"end_turn": [ACTIONS.END_TURN, 0],
	"get_gold_2": [ACTIONS.GET_GOLD, 2],
	"get_gold_4": [ACTIONS.GET_GOLD, 4],
	"get_card_1": [ACTIONS.GET_CARD, 1],
	"get_card_2": [ACTIONS.GET_CARD, 2],
}

var participant_id: int = 1
var available_actions: Dictionary = {}
var participant: BattleParticipant
var timer: bool = false

var chosen_action: String

func _ready() -> void:
	http_request = HTTPRequest.new()
	add_child(http_request)
	
	for x in NUM_UNIQUE_CARDS:
		action_map.set(("play_card_" + str(x)), [ACTIONS.PLAY_CARD, x])
	
	http_request.request_completed.connect(_on_request_completed)


func set_game_type(game_type: String):
	if game_type == "reinforcement":
		url = "https://gamewebai.onrender.com/ai/reinforce"
	else:
		url = "https://gamewebai.onrender.com/ai/move" #"http://127.0.0.1:8000/ai/move"


func update_state(state: GameState):
	available_actions = state.available_actions
	participant = state.battle_participants[participant_id]
	
	if state.battle_participants_type.has(1):
		timer = true 


func request_move(state_snapshot: Dictionary):
	if timer:
		await get_tree().create_timer(1.0).timeout
	
	if state_snapshot["available_actions"].size() == 1:
		end_turn_action()
		return
	else:
		
		send_request(state_snapshot)
		
		await action_set
		
		var action = action_map[chosen_action]
		
		if action[0] == ACTIONS.GET_CARD:
			get_card_action()
		elif action[0] == ACTIONS.GET_GOLD:
			get_gold_action()
		elif action[0] == ACTIONS.PLAY_CARD:
			var hand_card_values_id = participant.hand.values().find_custom(func(runtime_card): return runtime_card.get_id() == action[1])
			if hand_card_values_id != null:
				var hand_card_id = participant.hand.find_key(participant.hand.values()[hand_card_values_id])
				activate_card_action(hand_card_id)
		else:
			end_turn_action()


func send_request(state_snapshot: Dictionary):
	var headers = ["Content-Type: application/json"]
	http_request.request(url, headers, HTTPClient.METHOD_POST, JSON.stringify(state_snapshot))




func activate_card_action(card_id: int) -> void:
	var action = PlayCardAction.new()
	action.participant_id = participant_id
	action.card_id = card_id
	do_action.emit(action)


func get_card_action() -> void:
	var action = GetCardsAction.new()
	action.participant_id = participant_id
	if !available_actions.get(ACTIONS.GET_CARD):
		end_turn_action()
	else:
		action.cards_amount = available_actions.get(ACTIONS.GET_CARD)
		do_action.emit(action)


func get_gold_action() -> void:
	var action = GetGoldAction.new()
	action.participant_id = participant_id
	action.gold_amount = available_actions.get(ACTIONS.GET_GOLD)
	do_action.emit(action)


func end_turn_action() -> void:
	var action = EndTurnAction.new()
	action.participant_id = participant_id
	do_action.emit(action)


func _on_request_completed(_result, response_code, _headers, body):
	var response = body.get_string_from_utf8()
	print(response)
	if response_code == 200 or response_code == 201:
		chosen_action = JSON.parse_string(response)["chosen_action"]
	else:
		print("Failed to get an action ", " Code: ", response_code)
		chosen_action = "end_turn"
	action_set.emit()
