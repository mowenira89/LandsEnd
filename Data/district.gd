class_name District extends Resource

enum TYPES {Wild,Sacred,Agricultural,Industrial,Mining}

@export var biome:Biome
@export var type:TYPES
@export var territory:Territory
@export var building:Building
@export var index:int
@export var construction_time:int=0
@export var surveyed:bool=false

func create(t:Territory,i:int):
	territory=t
	index=i
	var r = randi_range(0,251)
	if r<5:
		type=TYPES.Sacred
	else:
		type=TYPES.Wild
	biome=Biome.new()
	biome.create()
