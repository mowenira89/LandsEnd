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
@export var dead_season:Array[GM.MONTHS]
var pest:Species
var current_health:float
var starting_up:int
var growth:float
var fertilizer_buffer:float=0
var fertilizer:Stuff

func create():
	current_health=health
	starting_up=startup_time
	growth=0

func save():
	var s = {}
	s['name']=name
	s['current_health']=current_health
	s['pest']=pest.name
	s['starting_up']=starting_up
	s['growth']=growth	


func fertilize(s:Stockpile):
	if fertilizer_buffer>0:
		fertilizer_buffer-=1
		if fertilizer_buffer<=0:
			if s.remove_stuff(fertilizer,1):
				fertilizer_buffer+=fertilizer.qualities[Stuff.QUALITIES.Fertilizer]


func grow(d:District,boss:Person):
	if GM.month in dead_season:
		growth=0
		return
	if starting_up>0:
		starting_up-=1
		return
	var growth_this_turn=0
	fertilize(d.territory.stockpile)
	if fertilizer_buffer>0:
		for x in d.biome.vitamins:
			d.biome.vitamins[x]+=fertilizer.qualities[Stuff.QUALITIES.Fertilizer]
	for y in vitamins:
		if d.biome.vitamins[y]<0:
			health-=.2
		else:
			d.biome.vitamins[y]-=vitamins[y]	
			growth_this_turn+=.2
			if fertilizer_buffer>0:
				growth_this_turn+=fertilizer.qualities[Stuff.QUALITIES.Fertilizer]/10
	if boss:
		growth_this_turn+=boss.get_prowess(Person.PROWESS.GreenThumb)/10 	
	growth+=growth_this_turn
	if GM.month in harvest_season:
		var produce = RM.stuff[name] if !produce else produce
		d.territory.stockpile.add_max(produce,growth)	
	
