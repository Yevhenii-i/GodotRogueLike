class_name GetCardsAction extends GameAction

var participant_id: int
var cards_amount: int
var card_data

func execute(state: GameState):
	var participant = state.get_participant(participant_id)
	
	for i in cards_amount:
		card_data = state.deck.get_random_card()
		participant.add_card(card_data)

	state.remove_action_availability(state.ACTIONS.GET_GOLD)
	state.remove_action_availability(state.ACTIONS.GET_CARD)
