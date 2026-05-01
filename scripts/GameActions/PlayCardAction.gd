class_name PlayCardAction extends GameAction

#var participant_id: int
var card_id: int

func execute(state: GameState):
	var participant = state.get_participant(participant_id)
	if !state.can_play_card(participant_id, card_id):
		return
	participant.play_card(card_id)
	
	state.reduce_action_availability(state.ACTIONS.PLAY_CARD, 1)

func to_dict(state: GameState) -> Dictionary:
	var card_data_id = state.get_card_data_id(participant_id, card_id)
	return {
		"type": "play_card",
		"card_data_id": card_data_id
	}
