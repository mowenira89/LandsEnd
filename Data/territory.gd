class_name Territory extends Resource

@export var name:String
@export var districts:Array[District]
@export var coords:Vector2i
@export var stockpile:Stockpile
@export var population:Population
@export var temp_jobs:Dictionary[Pop.CLASS,int]
@export var buffs:Array[Buff]
@export var nymphoi:Pop
	
func create(c:Vector2i):
	coords=c
	for x in 8:
		var nd = District.new()
		districts.append(nd)
		nd.create(self,x)
	population = Population.new()
	population.create(self)
	nymphoi=Pop.new()
	nymphoi.create(Pop.CLASS.Nymphoi,self)

func appoint_workers():
	var ratios = {}
	var have = population.get_population_breakdown()
	var needed = {}
	var to_appoint = {}
	for x in Pop.CLASS:
		needed[x]=0
		to_appoint[x]=0
		ratios[x]=0
	for x in districts:
		if x.building!=null:
			for y in x.building.staff_needed:
				needed[y]+=x.building.staff_needed[y]
	for x in temp_jobs:
		needed[x]+=temp_jobs[x]
	for x in needed:
		if needed[x]<=have[x]:
			to_appoint[x]=needed[x]
		else:
			ratios[x] = float(population.get_persons(x))/needed[x]
	for x in districts:
		if x.building!=null:
			for c in x.building.staff:
				if needed[x]>have[x]:
					x.building.staff_appointed[c]=x.building.staff[c]*ratios[c]
				else:
					x.building.staff_appointed[c]=x.staff[c]

func change_temp_jobs(c:Pop.CLASS,a:int):
	if c not in temp_jobs.keys():
		temp_jobs[c]=a
	else:
		temp_jobs[c]+=a

func check_water():
	var surrounding = GM.board.ground.get_surrounding_cells(coords)
	if surrounding.size()<6:
		return true
	else:
		return false

func add_buff(b:Buff):
	buffs.append(b)
	b.init(self)
	
func remove_buff(b:Buff):
	if b in buffs:
		buffs[buffs.find(b)].remove()

func get_pop_cap(c:Pop.CLASS)->int:
	var r=0
	for x in districts:
		if x.building and !x.building.pop_cap.is_empty():
			if x.building.pop_cap.has(c):
				r+=x.building.pop_cap[c]
	return r	

func assimilate(u:Unit):
	pass
