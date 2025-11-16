class_name NeedsRiverCondition extends Condition

func check(d:District=null,t:Territory=null,b:Building=null)->bool:
	return d.biome.rivers	
