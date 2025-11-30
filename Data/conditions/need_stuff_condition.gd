class_name NeedStuffCondition extends Condition

@export var stuff:Stuff

func check(t:Territory=null,d:District=null,b:Building=null,u:Unit=null)->bool:
	if stuff in t.stockpile.stuff.keys():
		return true
	return false
