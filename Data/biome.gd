class_name Biome extends Resource

enum TERRAIN {Field,Hills,Forest,Swamp,Barren,Water}
enum VITAMINS {A,B,C,D,K,Q,F}

@export var terrain:TERRAIN
@export var fauna:Dictionary[Species,float]
@export var flora:Dictionary[Species,float]
@export var fish:Dictionary[Species,float]
@export var rivers:bool
@export var water:float
@export var vitamins:Dictionary[VITAMINS,int]
@export var forage:Dictionary[Stuff,float]
@export var mineable:Stuff
@export var mineable_amount:int
@export var water_pollution:float
@export var air_pollution:float


var original_water:float
var original_vitamins:Dictionary

func create():
	terrain=randi_range(0,5)
	if terrain in [TERRAIN.Field,TERRAIN.Forest,TERRAIN.Hills]:
		rivers=randi_range(0,1)
	if terrain==TERRAIN.Barren: 
		water=0
	elif terrain==TERRAIN.Swamp:
		water=50000
	else:
		water=randi_range(5000,20000)
	original_water=water
	
	for x in VITAMINS.values():
		if !terrain==TERRAIN.Barren:	
			vitamins[x]=randi_range(1000,10000)
		else:
			vitamins[x]=randi_range(1,10)
	original_vitamins=vitamins.duplicate()
	set_flora_and_fauna()
	set_mineables()
	mineable_amount = randi_range(1000,10000)
	if mineable and mineable.qualities.has(Stuff.QUALITIES.Forage):
		forage[mineable]=mineable.qualities[Stuff.QUALITIES.Forage]
	
	
func set_flora_and_fauna():
	var potential=RM.species_by_habitat[terrain]
	for x in potential:
		if randi_range(0,101)<x.rarity:
			if x.kind==Species.KIND.Flora:
				flora[x]=x.rarity
			else:
				fauna[x]=x.rarity
	if rivers:
		var p = RM.species_by_habitat[TERRAIN.Water]
		for x in p:
			if randi_range(0,101)<x.rarity:
				fish[x]=x.rarity	
	if RM.species["Bee"] in fauna.keys():
		forage[RM.stuff["Honey"]]=RM.stuff["Honey"].qualities[Stuff.QUALITIES.Forage]
	for x in flora.keys():
		for y in x.kill_produce:
			if y not in forage.keys():
				forage[y]=y.qualities[Stuff.QUALITIES.Forage]
		
				

func set_mineables():
	var potential = RM.mineables_by_terrain[terrain].duplicate()
	potential.shuffle()
	for x in potential:
		if randi_range(0,101)<=x.qualities[Stuff.QUALITIES.Mineable]:
			mineable=x
			break

func get_game():
	var r = []
	for x in fauna:
		if x.game:
			r.append(x)
	return r
