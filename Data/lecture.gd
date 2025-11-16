class_name Lecture extends Event

@export var lecture_length:int
@export var subject:School.SUBJECTS
@export var building:School
@export var pop_training:Pop.CLASS
@export var training_bar:int
@export var research:Dictionary[Research,float]

func end_turn():
	turns-=1
	for x in effects:
		x.per_turn(turns)
		if turns<=0:
			x.apply()
			turns=lecture_length

func apply():
	var a = 0
	match pop_training:
		Pop.CLASS.Monk:
			a = building.district.territory.population.get_pop_stat(Pop.CLASS.Follower,Beliefs.STATS.Piety)*100
		Pop.CLASS.Artist:
			a = building.district.territory.population.get_pop_stat(Pop.CLASS.Follower,Beliefs.STATS.Creativity)*100
		Pop.CLASS.Soldier:
			a = building.district.territory.population.get_pop_stat(Pop.CLASS.Follower,Beliefs.STATS.Militancy)*100
	if a<0:
		a=5

	var buffs = get_buffs()
	
	for x in research:
		ResearchManager.research[x.name].add_exp(research[x],buffs,building.district.territory)

	var training_amt=0	
	for x in building.class_room_size:
		if randf_range(0,100)<a:
			training_amt+=1
			
	train_pop(building.district.territory.population,0,pop_training,training_amt)


	
func train_pop(p:Population, a:Pop.CLASS,b:Pop.CLASS,amt:int):
	if p.change_pop(a,-amt):
		p.change_pop(b,amt)
	

func get_buffs():
	var r:Array[Buffs] = []
	r.append(building.buffs)
	r.append(building.district.territory.buffs)
	for x in building.lecturers:
		r.append(x.personal_buffs)
	return r
