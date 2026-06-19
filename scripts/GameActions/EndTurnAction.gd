class_name EndTurnAction extends GameAction

func execute(state: GameState):
	@warning_ignore("unused_variable")
	var participant = state.get_participant(participant_id)
	if state.assigned_characters.find_key(participant_id) == state.active_character:
		state.clear_action_availability()
	else:
		return false
	return true

@warning_ignore("unused_parameter")
func to_str(state: GameState):
	return "end_turn"
	
	
