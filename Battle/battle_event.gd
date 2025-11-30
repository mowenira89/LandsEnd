class_name BattleEvent extends Event

var priority:int
var actor:Person
var target:BattleManager.TARGETS
var indv_target:Person
var slot_target:int
var allies:Array[PersonSelectorButton]
var enemies:Array[PersonSelectorButton]

func battle_init(a:Array[PersonSelectorButton],e:Array[PersonSelectorButton]):
	allies=a
	enemies=e

func apply():
	pass
