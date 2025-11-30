class_name MoveBattleEvent extends BattleEvent

var moving_to:PersonSelectorButton

func make_plans(p:Person,i:PersonSelectorButton):
	actor=p
	moving_to=i
	priority=1
	
func apply():
	if moving_to.person:
		return false
	
