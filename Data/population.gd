class_name Population extends Resource

var pops:Dictionary[Pop.CLASS,Pop]
var owner
var hunger:float
var vitamins:Dictionary[Biome.VITAMINS,int]
var temp_jobs:Dictionary[Pop.CLASS,int]

func create(t:Territory=null,u:Unit=null):
	if u:
		owner=u
	else:
		owner=t
	for x in Pop.CLASS.values():
		var new_pop = Pop.new()
		new_pop.create(x,t)
		pops[x]=new_pop
		

func get_total_population():
	var r=0
	for x in pops.values():
		r+=x.persons
	return r

func get_pops(c:Pop.CLASS):
	return pops[c].persons
	
func get_pop_breakdown():
	var r = {}
	for x in pops:
		r[x]=pops[x].persons
	return r
	
func consume():
	if hunger>0:
		for x in get_territory().stockpile.food_order:
			while hunger>0:
				pass
				
func assimilate_unit(u:Unit,mode:String):
	var followers = u.followers.pops
	for x in followers:
		var cap = get_territory().get_pop_cap(x)
		var current_pop = pops[x].persons
		var change=0
		if followers[x].persons>cap-current_pop:
			change = cap-current_pop
		else:
			change=followers[x].persons
		for b in followers[x].beliefs.stats:
			var num = ((followers[x].beliefs[b]*followers[x].persons)+(pops[x].beliefs[b]*pops[x].persons))/(followers[x].persons+pops[x].persons)
			followers[x].beliefs.stats[b]=num
			
		followers[x].persons-=change
		pops[x].persons+=change
		
		if followers[x].persons>0 and mode=="Disband":
			pops[Pop.CLASS.Underclass].persons+=followers[x].persons
		
		
func change_pop(c:Pop.CLASS,a:int):
	return pops[c].change_persons(a)
	
func move_to(to:Population,a:int,c:Pop.CLASS):
	if to.change_pop(c,a):
		to.change_pop(c,-a)

func get_population_name():
	return owner.name
	
func get_pop_stat(c:Pop.CLASS,s:Beliefs.STATS):
	return pops[c].beliefs.stats[s]

func get_territory():
	if owner is Unit:
		return owner.current_territory
	else:
		return owner
		

func appoint_workers():
	var ratios = {}
	var have = get_pop_breakdown()
	var needed = {}
	var to_appoint = {}
	for x in Pop.CLASS:
		needed[x]=0
		to_appoint[x]=0
		ratios[x]=0
	for x in get_territory().districts:
		if x.building!=null:
			for y in x.building.staff_needed:
				needed[y]+=x.building.staff_needed[y]
	for x in temp_jobs:
		needed[x]+=temp_jobs[x]
	for x in needed:
		if needed[x]<=have[x]:
			to_appoint[x]=needed[x]
		else:
			ratios[x] = float(get_pops(x))/needed[x]
	for x in get_territory().districts:
		if x.building!=null:
			for c in x.building.staff:
				if needed[x]>have[x]:
					x.building.staff_appointed[c]=x.building.staff[c]*ratios[c]
				else:
					x.building.staff_appointed[c]=x.staff[c]
	
	
func get_idle_pop(c:Pop.CLASS):
	var have = get_pops(c)
	var needed:int=0
	for x in get_territory().districts:
		if x.building!=null:
			for y in x.building.staff_needed:
				if y == c:
					needed+=x.building.staff_needed[c]
	return have-needed
	

func change_temp_jobs(c:Pop.CLASS,a:int):
	if c not in temp_jobs.keys():
		temp_jobs[c]=a
	else:
		temp_jobs[c]+=a

func get_pop_belief(c:Pop.CLASS,b:Beliefs.STATS):
	return pops[c].beliefs.stats[b]
