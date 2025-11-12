class_name NeedsTerrainCondition extends Condition

@export var terrain:Array[Biome.TERRAIN]

func check(d:District=null,t:Territory=null,b:Building=null)->bool:
	if d.biome.terrain in terrain:
		return true
	else:
		return false
