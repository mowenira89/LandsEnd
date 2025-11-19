class_name Crop extends Species

@export var id:String
@export var crop_level:int
@export var vitamins:Dictionary[Biome.VITAMINS,float]
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
@export var starting_up:int
@export var growth:float
