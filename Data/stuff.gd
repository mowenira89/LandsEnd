class_name Stuff extends Resource

enum QUALITIES {Food,Fuel,Luxury,Build,Clothes,Forage,Mineable,Offense,Defense,Alchemy,Sacred,Medicine,Capacity,Travel}

@export var name:String
@export var value:float
@export var qualities:Dictionary[QUALITIES,float]
@export var exp_to:Dictionary[String,float]
@export var found_in:Array[Biome.TERRAIN]
