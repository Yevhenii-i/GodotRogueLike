class_name GetGoldAction extends GameAction

var gold_amount: int

func execute(state: GameState):
	var participant = state.get_participant(participant_id)
	participant.add_gold(gold_amount)
	state.remove_action_availability(state.ACTIONS.GET_GOLD)
	state.remove_action_availability(state.ACTIONS.GET_CARD)
	
	return true

@warning_ignore("unused_parameter")
func to_str(state: GameState) -> String:
	return "get_gold_" + str(self.gold_amount)
	
