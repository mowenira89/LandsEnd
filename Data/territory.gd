class_name Territory extends Resource

var name:String
var districts:Array[District]
var coords:Vector2i
var stockpile:Stockpile
var population:Population
var temp_jobs:Dictionary[Pop.CLASS,int]
var buffs:Buffs
var nymphoi:Pop
var units:Array[Unit]=[]
var NPCs:Array[Person]=[]

func create(c:Vector2i):
	coords=c
	name = NM.territory_names.pick_random()+" "+NM.territory_names.pick_random()
	for x in 8:
		var nd = District.new()
		districts.append(nd)
		nd.create(self,x)
	population = Population.new()
	population.create(self)
	stockpile=Stockpile.new()
	stockpile.create(self)
	nymphoi=Pop.new()
	nymphoi.create(Pop.CLASS.Nymphoi,self)

func check_water():
	var surrounding = GM.board.ground.get_surrounding_cells(coords)
	if surrounding.size()<6:
		return true
	else:
		return false


func get_pop_cap(c:Pop.CLASS)->int:
	var r=0
	if c==Pop.CLASS.Underclass or c==Pop.CLASS.Nymphoi:
		return 10000
	for x in districts:
		if x.building and !x.building.pop_cap.is_empty():
			if x.building.pop_cap.has(c):
				r+=x.building.pop_cap[c]
	return r

func assimilate(u:Unit):
	pass

func get_pop(c:Pop.CLASS):
	return population.pops[c].persons

func get_known_fauna():
	var r = []
	for x in districts:
		for y in x.discovered_game:
			if y not in r:
				r.append(y)
	return r
	
func get_known_flora():
	var r = []
	for x in districts:
		for y in x.discovered_flora:
			if y not in r:
				r.append(y)
	return r
	
func get_known_resources():
	var r = []
	for x in districts:
		for y in x.discovered_resources:
			if y not in r:
				r.append(y)
	return r
		
func get_known_forage():
	var r = []
	for x in districts:
		for y in x.discovered_forage:
			if y not in r:
				r.append(y)
	return r
		
	
func end_turn():
	
	population.appoint_workers()
	for x in districts:
		if x.building:
			x.building.end_turn()
	for x in units:
		x.end_turn()
	population.end_turn()
	
func get_game():
	var r = []
	for x in districts:
		if x.type==0:
			for f in x.biome.fauna:
				if f not in r:
					r.append(f)
	return r		
			
func get_wild_district_indexes():
	var r = []
	for x in districts:
		if x.type==0:
			r.append(x.index)
	return r

func get_river_districts():
	var r = []
	for x in districts:
		if x.biome.terrain!=Biome.TERRAIN.Barren:
			r.append(x.index)
	return r

func save():
	var s={}
	s['name']=name

func get_mineable_districts():
	var r = []
	for x in districts:
		if x.biome.mineable:
			r.append(x)
	return r

func get_attractiveness():
	var amt=0
	for x in districts:
		amt+=x.get_attractiveness()
	return amt/8

func extract_products():
	var r = {}
	for d in districts:
		for x in d.biome.fauna:
			if x.aggressiveness<3:
				if r.has(x):
					r[x]=(r[x]+d.biome.fauna[x])/2
				else:
					r[x]=d.biome.fauna[x]
		for x in d.biome.flora:
			if x.qualities.has(Stuff.QUALITIES.Forage):
				if r.has(x):
					r[x]=(r[x]+d.biome.flora[x])/2
				else:
					r[x]=d.biome.flora[x]
		for x in d.biome.forage:
			if r.has(x):
				r[x]=(r[x]+d.biome.forage[x])/2
			else:
				r[x]=d.biome.forage[x]
		if d.biome.mineable:
			var x = d.biome.mineable
			r[x]=x.qualities[Stuff.QUALITIES.Mineable]

		return r
