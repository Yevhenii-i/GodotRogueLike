class_name GetCardsAction extends GameAction

#var participant_id: int
var cards_amount: int
var runtime_card: RuntimeCard

func execute(state: GameState):
	var participant = state.get_participant(participant_id)
	
	for i in cards_amount:
		runtime_card = state.deck.get_random_card()
		participant.add_card(runtime_card)
	
	state.remove_action_availability(state.ACTIONS.GET_GOLD)
	state.remove_action_availability(state.ACTIONS.GET_CARD)

func to_str(state: GameState) -> String:
	return "get_card_" + str(self.cards_amount)
