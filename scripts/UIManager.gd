class_name UIManager extends Node

enum ACTIONS { PLAY_CARD = 1, GET_GOLD = 2, GET_CARD = 3, END_TURN = 10 }

signal do_action(action: GameAction)

@onready var playerArea = $PlayerTownArea
@onready var playerHand = $PlayerHand
@onready var playerMoneyLabel = $PlayerMoney/MoneyAmount
@onready var moneyButton = $MoneyButton
@onready var deckButton = $DeckButton
@onready var endTurnButton = $EndTurnButton

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
	
	if available_actions.get(ACTIONS.END_TURN):
		endTurnButton.disabled = false
	else:
		endTurnButton.disabled = true

	
	var player = state.battle_participants[player_id]
	if !player.hand.is_empty():
		if available_actions.get(ACTIONS.PLAY_CARD):
			for card_id in player.hand.keys():
				var card = playerHand.hand[card_id]
				if card.cardCost <= player.get_gold():
					card.playability = true
				else:
					card.playability = false
		else:
			for card_id in player.hand.keys():
				var card = playerHand.hand[card_id]
				card.playability = false



func update_graphics(state: GameState):
	playerMoneyLabel.set_text(str(state.battle_participant1.get_gold()))
	
	for i in state.battle_participant1.hand_changes[BattleParticipant.CHANGES_TYPES.ADDED]:
		playerHand.add_card(i, state.battle_participant1.hand[i])
	state.battle_participant1.hand_changes[BattleParticipant.CHANGES_TYPES.ADDED] = []
	
	for i in state.battle_participant1.area_changes[BattleParticipant.CHANGES_TYPES.ADDED]:
		playerArea.add_card(i)
	state.battle_participant1.area_changes[BattleParticipant.CHANGES_TYPES.ADDED] = []


func update(state: GameState):
	update_graphics(state)
	set_availability(state)


func _on_player_hand_card_activate(card_id: int, card: Card) -> void:
	var action = PlayCardAction.new()
	action.participant_id = player_id
	action.card_id = card_id
	action.card = card
	do_action.emit(action)

func _on_deck_button_pressed() -> void:
	var action = GetCardsAction.new()
	action.participant_id = player_id
	action.cards_amount = available_actions.get(ACTIONS.GET_CARD)
	do_action.emit(action)


func _on_money_button_pressed() -> void:
	var action = GetGoldAction.new()
	action.participant_id = player_id
	action.gold_amount = available_actions.get(ACTIONS.GET_GOLD)
	do_action.emit(action)


func _on_end_turn_button_pressed() -> void:
	var action = EndTurnAction.new()
	action.participant_id = player_id
	do_action.emit(action)
