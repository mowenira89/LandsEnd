class_name NeedsTerrainCondition extends Condition

@export var terrain:Array[Biome.TERRAIN]

func check(t:Territory=null,d:District=null,b:Building=null,u:Unit=null)->bool:
	if d.biome.terrain in terrain:
		return true
	else:
		return false
