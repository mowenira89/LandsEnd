class_name NeedResourceCondition extends Condition

@export var stuff:Stuff

func check(t:Territory=null,d:District=null,b:Building=null,u:Unit=null)->bool:
	if d.biome.mineable:
		return true
	return false
