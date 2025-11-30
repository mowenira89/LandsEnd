class_name BuildingLevelCondition extends Condition

@export var level:int

func check(t:Territory=null,d:District=null,b:Building=null,u:Unit=null)->bool:
	if b.level>=level:
		return true
	return false
