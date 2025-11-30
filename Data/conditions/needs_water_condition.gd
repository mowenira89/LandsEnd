class_name NeedsWaterCondition extends Condition

func check(t:Territory=null,d:District=null,b:Building=null,u:Unit=null)->bool:
	if d.territory.check_water():
		return true
	else:
		return d.biome.rivers	
