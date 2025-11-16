class_name Territory extends Resource

@export var name:String
@export var districts:Array[District]
@export var coords:Vector2i
@export var stockpile:Stockpile
@export var population:Population
@export var temp_jobs:Dictionary[Pop.CLASS,int]
@export var buffs:Buffs
@export var nymphoi:Pop
@export var units:Array[Unit]=[]
@export var NPCs:Array[Person]=[]
	
func create(c:Vector2i):
	coords=c
	for x in 8:
		var nd = District.new()
		districts.append(nd)
		nd.create(self,x)
	population = Population.new()
	population.create(self)
	stockpile=Stockpile.new()
	stockpile.owner=self
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
			r.append(y)
	return r
	
func get_known_flora():
	var r = []
	for x in districts:
		for y in x.discovered_flora:
			r.append(y)
	return r
	
func get_known_resources():
	var r = []
	for x in districts:
		for y in x.discovered_resources:
			r.append(y)
	return r
		
func get_known_forage():
	var r = []
	for x in districts:
		for y in x.discovered_forage:
			r.append(y)
	return r
		
	
func end_turn():
	
	population.appoint_workers()
	for x in districts:
		if x.building:
			x.building.end_turn()
	
	for x in NPCs:
		x.end_turn()
	for x in units:
		x.end_turn()

func get_game():
	var r = []
	for x in districts:
		if x.type==0:
			for f in x.biome.fauna:
				if f not in r:
					r.append(f)
	return r		
			
