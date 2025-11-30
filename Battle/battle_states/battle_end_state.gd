class_name BattleEndState extends BattleState

func enter():
	BattleManager.battle.end_battle()

func get_state_name()->String:
	return "EndState"
