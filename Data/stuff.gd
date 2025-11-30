class_name Stuff extends Resource

enum QUALITIES {Food,Fuel,Luxury,Build,Clothes,Forage,Mineable,Offense,Defense,Alchemy,
Sacred,Medicine,Capacity,Travel,Scholarly,Incense,Sculpture,Libation,Instrument,
ForageCapacity,Preservable,Fertilizer,Feed}

enum MYSTIC {Sylvan,Cthonic,Water,Fire,Divine,Eldrich,Air}
	#VITAMINS A      B      C     D     K      Q      F
@export var name:String
@export var stats:Stats
@export var value:float
@export var qualities:Dictionary[QUALITIES,float]
@export var mystic_qualities:Dictionary[MYSTIC,float]
@export var exp_to:Dictionary[String,float]
@export var outfit_buffs:Array[Buff]
@export var found_in:Array[Biome.TERRAIN]
@export var prohibited:bool=false
@export var conveys_prowess:Dictionary[Person.PROWESS,float]
@export var food_type:Food.FOOD_TYPE
@export var diet_type:Array[Species.DIET]

func get_quality(q:QUALITIES):
	if qualities.has(q):
		return qualities[q]
	else:
		return 0
