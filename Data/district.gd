class_name District extends Resource

enum TYPES {Wild,Sacred,Agricultural,Industrial,Mining,Military,Residential}

@export var name:String
@export var biome:Biome
@export var type:TYPES
@export var territory:Territory
@export var building:Building
@export var index:int
@export var construction_time:int=0

@export var discovered_game:Array[Species]
@export var discovered_flora:Array[Species]
@export var discovered_resources:Array[Stuff]
@export var discovered_forage:Array[Stuff]

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
	name = "District "+str(i)

func fauna_spotted(s:Species):
	if s not in discovered_game:
		discovered_game.append(s)
		#SEND MESSAGE
		
func flora_spotted(s:Species):
	if s not in discovered_flora:
		discovered_flora.append(s)

func resource_spotted(s:Stuff):
	if s not in discovered_resources:
		discovered_resources.append(s)
		
func forage_spotted(s:Stuff):
	if s not in discovered_forage:
		discovered_forage.append(s)
