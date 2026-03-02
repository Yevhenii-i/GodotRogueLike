class_name PlayCardAction extends GameAction

var participant_id: int
var card_id: int
var card: Card

func execute(state: GameState):
	var participant = state.get_participant(participant_id)
	participant.play_card(card_id, card)
	
	state.reduce_action_availability(state.ACTIONS.PLAY_CARD, 1)
