class_name UnlockBuildingEffect extends Effect

@export var buildings:Array[Building]

func apply():
	for x in buildings:
		if x not in GM.unlocked_buildings:
			GM.unlocked_buildings.append(x)
			GM.end_turn_message.emit("You've unlocked the "+x.name+"! Build one today!")	
