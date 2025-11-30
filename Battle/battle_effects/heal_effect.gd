class_name HealEffect extends BattleEffect

@export var amt:float

func apply(e:BattleEvent):
	e.indv_target.stats.change_hp(amt)
