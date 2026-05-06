class_name UIManager extends Node

enum ACTIONS { PLAY_CARD = 1, GET_GOLD = 2, GET_CARD = 3, END_TURN = 10 }

signal do_action(action: GameAction)
signal end_game()

@onready var playerArea = $PlayerTownArea
@onready var enemyArea = $EnemyTownArea
@onready var playerHand = $PlayerHand
@onready var enemyHand = $EnemyHand
@onready var playerMoneyLabel = $PlayerMoney/MoneyAmount
@onready var enemyMoneyLabel = $EnemyMoney/MoneyAmount
@onready var moneyButton = $MoneyButton
@onready var deckButton = $DeckButton
@onready var endTurnButton = $EndTurnButton
@onready var gameRoundLabel = $GameRoundLabel
@onready var characters = [$CharacterArea/FIRST, $CharacterArea/SECOND, $CharacterArea/THIRD]
@onready var gameResults = $GameResults
@onready var gameResultsLabel = $GameResults/GameResultLabel
@onready var returnButton = $GameResults/ReturnToMainMenuButton

var participant_id: int = 0
var available_actions: Dictionary = {}


func set_availability(state: GameState):
	available_actions = state.available_actions
	moneyButton.disabled = !available_actions.has(ACTIONS.GET_GOLD)
	deckButton.disabled = !available_actions.has(ACTIONS.GET_CARD)
	endTurnButton.disabled = !available_actions.has(ACTIONS.END_TURN)

	
	var player = state.battle_participants[participant_id]
	if !player.hand.is_empty():
		for card_id in player.hand.keys():
			var card = playerHand.hand[card_id]
			card.set_playable(state.can_play_card(participant_id, card_id))




func update_graphics(state: GameState):
	for character_id in characters.size():
		if state.active_character == character_id+1:
			characters[character_id].set_visible(true)
		else:
			characters[character_id].set_visible(false)
	gameRoundLabel.set_text(str(state.game_round))
	
	playerMoneyLabel.set_text(str(state.battle_participants[0].get_gold()))
	
	var player = state.battle_participants[participant_id]
	var hand_changes = player.consume_hand_changes()
	for card_id in hand_changes[BattleParticipant.CHANGES_TYPES.ADDED]:
		playerHand.add_card(card_id, player.hand[card_id])
	for card_id in hand_changes[BattleParticipant.CHANGES_TYPES.REMOVED]:
		playerHand.remove_card(card_id)
	
	var area_changes = player.consume_area_changes()
	for card_id in area_changes[BattleParticipant.CHANGES_TYPES.ADDED]:
		playerArea.add_card(card_id, player.active_cards[card_id])
	for card_id in area_changes[BattleParticipant.CHANGES_TYPES.REMOVED]:
		playerArea.remove_card(card_id)
	
	#переставити все знизу в цикл, дублювання
	enemyMoneyLabel.set_text(str(state.battle_participants[1].get_gold()))
	
	var enemy = state.battle_participants[1]
	hand_changes = enemy.consume_hand_changes()
	for card_id in hand_changes[BattleParticipant.CHANGES_TYPES.ADDED]:
		enemyHand.add_card()
	for card_id in hand_changes[BattleParticipant.CHANGES_TYPES.REMOVED]:
		enemyHand.remove_card()
	
	area_changes = enemy.consume_area_changes()
	for card_id in area_changes[BattleParticipant.CHANGES_TYPES.ADDED]:
		enemyArea.add_card(card_id, enemy.active_cards[card_id])
	for card_id in area_changes[BattleParticipant.CHANGES_TYPES.REMOVED]:
		enemyArea.remove_card(card_id)


func update_state(state: GameState):
	update_graphics(state)
	set_availability(state)


func init_end_game(winner: int):
	if winner == participant_id:
		gameResultsLabel.set_text("YOU WON!!!")
	else: 
		gameResultsLabel.set_text("YOU LOST...")
	gameResults.set_visible(true)


func _on_player_hand_card_activate(card_id: int) -> void:
	var action = PlayCardAction.new()
	action.participant_id = self.participant_id
	action.card_id = card_id
	do_action.emit(action)


func _on_deck_button_pressed() -> void:
	var action = GetCardsAction.new()
	action.participant_id = self.participant_id
	action.cards_amount = available_actions.get(ACTIONS.GET_CARD)
	do_action.emit(action)


func _on_money_button_pressed() -> void:
	var action = GetGoldAction.new()
	action.participant_id = self.participant_id
	action.gold_amount = available_actions.get(ACTIONS.GET_GOLD)
	do_action.emit(action)


func _on_end_turn_button_pressed() -> void:
	var action = EndTurnAction.new()
	action.participant_id = self.participant_id
	do_action.emit(action)


func _on_return_to_main_menu_button_pressed() -> void:
	end_game.emit()
	pass # Replace with function body.
