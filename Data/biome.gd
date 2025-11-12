class_name Biome extends Resource

enum TERRAIN {Field,Hills,Forest,Swamp,Barren,Water}
enum VITAMINS {A,B,C,D,K,Q}

@export var terrain:TERRAIN
@export var fauna:Dictionary[Species,float]
@export var flora:Dictionary[Species,float]
@export var fish:Dictionary[Species,float]
@export var rivers:bool
@export var water:float
@export var vitamins:Dictionary[VITAMINS,int]
@export var forage:Dictionary[Stuff,float]
@export var mineable:Stuff

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
	
