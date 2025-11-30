class_name SpellBattleEvent extends BattleEvent

var spell:Spell

func make_plans(p:Person,s:Spell,t:Person=null,st:int=-1):
	actor=p
	indv_target=t
	spell=s
	slot_target=st


func apply():
	spell.apply(self)
