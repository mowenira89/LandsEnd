class_name Biome extends Resource

enum TERRAIN {Field,Hills,Forest,Swamp,Barren,Water,Underground}
enum VITAMINS {A,B,C,D,K,Q,F}

@export var terrain:TERRAIN
@export var fauna:Dictionary[Stuff,float]
@export var flora:Dictionary[Stuff,float]
@export var fish:Dictionary[Stuff,float]
@export var rivers:bool
@export var water:float
@export var vitamins:Dictionary[VITAMINS,float]
@export var forage:Dictionary[Stuff,float]
@export var mineable:Stuff
@export var mineable_amount:int
@export var water_pollution:float
@export var air_pollution:float
@export var timber:int
@export var original_timber:int
@export var spiritual_pollution:float
var original_water:float
var original_vitamins:Dictionary

func create():
	terrain=randi_range(0,4)
	if terrain in [TERRAIN.Field,TERRAIN.Forest,TERRAIN.Hills]:
		rivers=randi_range(0,1)
	if terrain==TERRAIN.Barren: 
		water=0
	elif terrain==TERRAIN.Swamp:
		water=50000
	else:
		water=randi_range(5000,20000)
	original_water=water
	original_timber=randi_range(1000,5000)
	if terrain==TERRAIN.Forest:
		original_timber*=3
	timber=original_timber
	for x in VITAMINS.values():
		if !terrain==TERRAIN.Barren:	
			vitamins[x]=randi_range(1000,10000)
		else:
			vitamins[x]=randi_range(1,10)
	original_vitamins=vitamins.duplicate()
	set_flora_and_fauna()
	set_mineables()
	if mineable and mineable.qualities.has(Stuff.QUALITIES.Forage):
		forage[mineable]=mineable.qualities[Stuff.QUALITIES.Forage]
	
	
func set_flora_and_fauna():
	var potential=RM.species_by_habitat[terrain]
	for x in potential:
		if randi_range(0,101)<x.rarity:
			if x.kind==Species.KIND.Flora:
				flora[x]=randf_range(1,x.rarity)
			else:
				fauna[x]=randf_range(1,x.rarity)
	if terrain!=TERRAIN.Barren:
		var p = RM.species_by_habitat[TERRAIN.Water]
		for x in p:
			if randi_range(0,101)<x.rarity:
				fish[x]=x.rarity	
	if RM.species["Bee"] in fauna.keys():
		forage[RM.stuff["Beehive"]]=RM.stuff["Beehive"].qualities[Stuff.QUALITIES.Forage]
	for x in flora.keys():
		if x.qualities.has(Stuff.QUALITIES.Forage):
			forage[x]=x.qualities[Stuff.QUALITIES.Forage]
		if x is Crop:
			for y in x.produce:
				if y not in forage.keys():
					forage[y]=y.qualities[Stuff.QUALITIES.Forage]
				
				

func set_mineables():
	var potential = RM.mineables_by_terrain[terrain].duplicate()
	potential.shuffle()
	for x in potential:
		if randi_range(0,101)<=x.qualities[Stuff.QUALITIES.Mineable]:
			mineable=x
			break
	mineable_amount = randi_range(1000,10000)

func get_game():
	var r = {}
	for x in fauna:
		if x.game:
			r[x]=fauna[x]
	return r


func save():
	var s = {}
	s['terrain']=terrain
	s["fauna"]={}
	s['flora']={}
	s['fish']={}
	for x in fauna:
		s['fauna'][x.name]=fauna[x]
	for x in flora:
		s['flora'][x.name]=flora[x]
	for x in fauna:
		s['fauna'][x.name]=fish[x]
	s['water']=water
	s['vitamins']=vitamins.duplicate()	
	s['forage']={}
	for x in forage:
		s['forage'][x.name]=forage[x]
	s['mineable']=mineable.name
	s['mineable_amt']=mineable_amount
	s['water_pollution']=water_pollution
	s['timber']=timber
	s['air_pollution']=air_pollution
	s['spiritual_pollution']=spiritual_pollution
	s['original_vitamins']=original_vitamins.duplicate()
	s['original_timber']=original_timber
	s['original_water']=original_water
	return s

func _load(s):
	terrain=s['terrain']
	for x in s["fauna"]:
		fauna[RM.species[x]]=s['fauna'][x]
	for x in s["flora"].keys():
		if RM.stuff[x] is Species:
			flora[RM.stuff[x]]=s['flora'][x]
		flora[RM.species[x]]=s['flora'][x]
	for x in s["fish"]:
		fish[RM.species[x]]=s['fish'][x]
	water=s['water']
	vitamins=s['vitamins'].duplicate()	
	for x in s['forage']:
		forage[RM.stuff[x]]=s['forage'][x]
	mineable=s[RM.stuff[s['mineable']]]
	mineable_amount=s['mineable_amt']
	water_pollution=s['water_pollution']
	timber=s['timber']
	air_pollution=s['air_pollution']
	spiritual_pollution=s['spiritual_pollution']
	original_vitamins=s['original_vitamins'].duplicate()
	original_timber=s['original_timber']
	original_water=s['original_water']
