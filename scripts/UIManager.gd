class_name UIManager extends Node

enum ACTIONS { BUILD = 1, GET_GOLD = 2, GET_CARD = 3 }

signal do_action(action: GameAction)

@onready var playerArea = $PlayerTownArea
@onready var playerHand = $PlayerHand
@onready var playerMoneyLabel = $PlayerMoney/MoneyAmount
@onready var moneyButton = $MoneyButton
@onready var deckButton = $DeckButton

var player_id: int = 0
var available_actions: Dictionary = {}


func set_availability(state: GameState):
	available_actions = state.available_actions
	if available_actions.get(ACTIONS.GET_GOLD):
		moneyButton.disabled = false
	else:
		moneyButton.disabled = true
	
	if available_actions.get(ACTIONS.GET_CARD):
		deckButton.disabled = false
	else:
		deckButton.disabled = true


func update_graphics(state: GameState):
	playerMoneyLabel.set_text(str(state.battle_participant1.get_gold()))
	
	for i in state.battle_participant1.hand_changes[BattleParticipant.HAND_CHANGES_TYPES.ADDED]:
		playerHand.add_card(i, state.battle_participant1.hand[i])
	state.battle_participant1.hand_changes[BattleParticipant.HAND_CHANGES_TYPES.ADDED] = []


func update(state: GameState):
	set_availability(state)
	update_graphics(state)


func _on_player_hand_card_activate(card: Card) -> void:
	playerArea.add_card(card)
	pass # Replace with function body.


func _on_deck_button_pressed() -> void:
	var action = GetCardsAction.new()
	action.participant_id = player_id
	action.cards_amount = available_actions.get(ACTIONS.GET_CARD)
	do_action.emit(action)
	pass
	#var card_data = state.deck.get_random_card()
	#playerHand.add_card(card_data)


func _on_money_button_pressed() -> void:
	var action = GetGoldAction.new()
	action.participant_id = player_id
	action.gold_amount = available_actions.get(ACTIONS.GET_GOLD)
	do_action.emit(action)
	pass
