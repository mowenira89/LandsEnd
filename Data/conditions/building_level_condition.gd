class_name BuildingLevelCondition extends Condition

@export var level:int

func check(d:District=null,t:Territory=null,b:Building=null)->bool:
	if b.level>=level:
		return true
	return false
