class_name NeedsRiverCondition extends Condition

func check(t:Territory=null,d:District=null,b:Building=null,u:Unit=null)->bool:
	if !d:
		return false
	return d.biome.rivers	
