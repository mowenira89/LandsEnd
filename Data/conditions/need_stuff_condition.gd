class_name NeedStuffCondition extends Condition

@export var stuff:Stuff

func check(d:District=null,t:Territory=null,b:Building=null)->bool:
	if stuff in t.stockpile.stuff.keys():
		return true
	return false
