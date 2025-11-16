class_name NeedResourceCondition extends Condition

@export var stuff:Stuff

func check(d:District=null,t:Territory=null,b:Building=null)->bool:
	if d.biome.mineable:
		return true
	return false
