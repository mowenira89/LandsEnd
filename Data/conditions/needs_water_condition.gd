class_name NeedsWaterCondition extends Condition

func check(d:District=null,t:Territory=null,b:Building=null)->bool:
	if d.territory.check_water():
		return true
	else:
		return d.biome.rivers	
