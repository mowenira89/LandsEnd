class_name Crop extends Resource

@export var name:String
@export var id:String
@export var crop_level:int
@export var vitamin_need:float
@export var vitamins_needed:Array[Biome.VITAMINS]
@export var water_need:float
@export var growth_mod:float
@export var health:float
@export var startup_time:float
@export var produce:Array[Stuff]
@export var special_produce:Array[Stuff]
@export var harvest_season:Array[GM.MONTHS]
@export var dead_season:Array[GM.MONTHS]
var pest:Species
var current_health:float
