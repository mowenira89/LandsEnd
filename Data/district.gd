class_name District extends Resource

enum TYPES {Wild,Sacred,Agricultural,Industrial,Mining,Military,Residential}

var name:String
var biome:Biome
var type:TYPES
var territory:Territory
var building:Building
var index:int
var construction_time:int=0
var attractiveness:float=0
var chief:Nymphoi
var blurses:Dictionary[Nymphoi.BLURSES,float] = {}
var utilized_by:int

var discovered_game:Array[Species]=[]
var discovered_flora:Array[Species]=[]
var discovered_resources:Array[Stuff]=[]
var discovered_forage:Array[Stuff]=[]

func create(t:Territory,i:int):
	territory=t
	index=i
	var r = randi_range(0,251)
	if r<5:
		type=TYPES.Sacred
		attractiveness=100
	else:
		type=TYPES.Wild
		attractiveness=10
	biome=Biome.new()
	biome.create()
	name = "District "+str(i)

func fauna_spotted(s:Species):
	if s not in discovered_game:
		GM.menus.end_turn_box.get_message("Discovered "+s.name+" in "+name+"!")
		discovered_game.append(s)
		#SEND MESSAGE
		
func flora_spotted(s:Species):
	if s not in discovered_flora:
		GM.menus.end_turn_box.get_message("Discovered "+s.name+" in "+name+"!")
		discovered_flora.append(s)
		if s.qualities.has(Stuff.QUALITIES.Forage) and s not in discovered_forage:
			discovered_forage.append(s)

func resource_spotted(s:Stuff):
	if s:
		if s not in discovered_resources:
			GM.menus.end_turn_box.get_message("Discovered "+s.name+" in "+name+"!")
			discovered_resources.append(s)
		
func forage_spotted(s:Stuff):
	if s not in discovered_forage:
		GM.menus.end_turn_box.get_message("Discovered "+s.name+" in "+name+"!")
		discovered_forage.append(s)


func save():
	var s = {}
	s['name']=name
	s['biome']=biome.save()
	s['type']=type
	s['territory']=territory.coords
	if building:
		s['building']=building.save()
	else:
		s['building']=null
	s['index']=index
	s['utilized_by']=utilized_by
	s['construction_time']=construction_time
	s['attractiveness']=attractiveness
	s['chief']=chief.id
	s['blurses']=blurses.duplicate()
	s['discovered_game']=[]
	s['discovered_resources']=[]
	s['discovered_flora']=[]
	s['discovered_forage']=[]
	for x in discovered_game:
		s['discovered_game'].append(x.name)
	for x in discovered_flora:
		s['discovered_flora'].append(x.name)
	for x in discovered_forage:
		s['discovered_forage'].append(x.name)
	for x in discovered_resources:
		s['discovered_resources'].append(x.name)
	return s
	
func _load(d:Dictionary):
	name=d['name']
	biome._load(d['biome'])
	type=d['type']
	territory=GM.board.tiles_by_cell[d['territory']].data
	if d['building']:
		building=RM.buildings[d['building']['name']]
	index=d['index']
	utilized_by = d['utilized_by']
	construction_time=d['construction_time']
	attractiveness=d['attractiveness']
	chief=RM.people_by_id[d['chief']]
	blurses = d['blurses'].duplicate()
	for x in d['discovered_game']:
		discovered_game.append(RM.species[x])
	for x in d['discovered_flora']:
		discovered_flora.append(RM.stuff[x])
	for x in d['discovered_forage']:
		discovered_forage.append(RM.stuff[x])
	for x in d['discovered_resources']:
		discovered_resources.append(RM.stuff[x])

func get_attractiveness():
	var amt = attractiveness
	amt-=biome.air_pollution
	amt-=biome.spiritual_pollution
	if building:
		amt+=building.attractiveness_boost
	return amt
