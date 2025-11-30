class_name Lecture extends Event

@export var name:String
@export var lecture_length:int
@export var subject:School.SUBJECTS
@export var building:School
@export var pop_training:Array[Pop.CLASS]
@export var difficulty:int
@export var research:Dictionary[Research,float]
var lecturer:Person
@export var lecturer_type:Pop.CLASS
@export var NPC_training:Dictionary[Person,float]
@export var convey_prowess:Array[Person.PROWESS]
@export var teaches_recipe:Array[Recipe]
var wisdom=0
var teacher=0
var exp_value:float=0
@export_multiline var desc:String 

func make_plans(l:Person,b:Building):
	building=b
	lecturer=l
	if lecturer:
		wisdom=lecturer.get_prowess(Person.PROWESS.Wise)
		teacher=lecturer.get_prowess(Person.PROWESS.Teacher)
	
	
func add_lecturer(p:Person):
	lecturer=p
	lecturer.in_building=building
	
func remove_lecturer():
	lecturer.in_building=null
	lecturer=null
	
func end_turn():
	turns-=1
	if turns<=0:
		apply()
		turns=lecture_length

func per_turn(turns):
	if !research.is_empty():
		for x in research:
			exp_value+=research[x]
			if lecturer and x in lecturer.knowledge:
				exp_value+=wisdom+teacher

func apply():
	for x in pop_training:
		var a = 0
		match x:
			Pop.CLASS.Monk:
				a = building.district.territory.population.get_pop_stat(Pop.CLASS.Follower,Beliefs.STATS.Piety)*100
			Pop.CLASS.Artist:
				a = building.district.territory.population.get_pop_stat(Pop.CLASS.Follower,Beliefs.STATS.Creativity)*100
			Pop.CLASS.Soldier:
				a = building.district.territory.population.get_pop_stat(Pop.CLASS.Follower,Beliefs.STATS.Militancy)*100
		if a<0:
			a=difficulty
			a+=teacher+wisdom
		var training_amt=0	
		for y in building.class_room_size:
			if randf_range(0,100)<a:
				training_amt+=1
		for y in training_amt:		
			train_pop(building.district.territory.population,0,pop_training[x],training_amt)
		
	if !research.is_empty():
		
		
		for x in research:
			var amt = research[x]+wisdom
			x.add_exp(exp_value,building)
	
	

	
func train_pop(p:Population, a:Pop.CLASS,b:Pop.CLASS,amt:int):
	if p.get_idle_pop(Pop.CLASS.Follower)<=0:
		return false
	if p.change_pop(a,-amt):
		p.change_pop(b,amt)
	

func get_buffs():
	var r:Array[Buffs] = []
	r.append(building.buffs)
	r.append(building.district.territory.buffs)
	for x in building.lecturers:
		r.append(x.personal_buffs)
	return r
