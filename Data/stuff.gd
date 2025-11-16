class_name Stuff extends Resource

enum QUALITIES {Food,Fuel,Luxury,Build,Clothes,Forage,Mineable,Offense,Defense,Alchemy,
Sacred,Medicine,Capacity,Travel,Scholarly}

@export var name:String
@export var value:float
@export var qualities:Dictionary[QUALITIES,float]
@export var exp_to:Dictionary[String,float]
@export var outfit_buffs:Array[Buff]
@export var found_in:Array[Biome.TERRAIN]

func get_sacred():
	if Stuff.QUALITIES.Sacred in qualities.keys():
		return qualities[Stuff.QUALITIES.Sacred]
	return false
		
func get_food():
	if Stuff.QUALITIES.Food in qualities.keys():
		return qualities[Stuff.QUALITIES.Food]
	return false
	
func get_build():
	if Stuff.QUALITIES.Build in qualities.keys():
		return qualities[Stuff.QUALITIES.Build]
		
func get_luxury():
	if Stuff.QUALITIES.Luxury in qualities.keys():
		return qualities[Stuff.QUALITIES.Luxury]
	
	
