class_name EndTurnAction extends GameAction

#var participant_id: int

func execute(state: GameState):
	var participant = state.get_participant(participant_id)
	state.clear_action_availability()

func to_dict(state: GameState):
	return {
		"type": "end_turn"
	}
	
