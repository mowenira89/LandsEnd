class_name Research extends Resource

@export var name:String
@export var unlocked:bool=false
@export var recipes:Array[Recipe]=[]
@export var buildings:Array[Building]=[]
@export var ceremonies:Array[Ceremony]=[]
@export var lectures:Array[Lecture]=[]
@export var people:Array[Person]
@export var exp_to_unlock:int
@export var current_exp:float=0
@export var prerequisites:Array[Research]
@export var inspiration_threshold:float
@export var inspired_class:Pop.CLASS
@export var conditions:Array[Condition]

func add_exp(a:float,b:Building=null,u:Unit=null,d:District=null):
	var t = u.current_territory if u else b.district.territory
	var wise=0
	var maverick=0
	if !d:
		if b:
			d=b.district
	for x in conditions:
		if !x.check(t,d,b,u):
			return false
	if b and b.boss:
		wise = b.boss.get_prowess(Person.PROWESS.Wise)
		maverick=b.boss.get_prowess(Person.PROWESS.Maverick)
	elif u:
		maverick=u.get_prowess(Person.PROWESS.Maverick)
		wise = u.get_prowess(Person.PROWESS.Wise)
	a+=wise
	for x in prerequisites:
		if !ResearchManager.research[x.name].unlocked:
				return false
	var p = u.followers if u else t.population
	var creativity = p.get_pop_belief(inspired_class,Beliefs.STATS.Creativity)
	creativity+=maverick*(wise+1)
	if randf()<(creativity/(inspiration_threshold/100)+creativity):
		a*=2
	current_exp+=a
	if current_exp>=exp_to_unlock:
		if randf()<(creativity/(inspiration_threshold/100)+creativity)+(maverick*(wise+1)):
			unlock()
	return true
	
func unlock():
	for x in buildings:
		x.unlocked=true
		if x not in GM.unlocked_buildings:
			GM.unlocked_buildings.append(x)
	for x in people:
		RM.NPCs[x.name].unlocked=true
	for x in recipes:
		RM.recipes[x.id].unlocked=true
	GM.menus.end_turn_box.get_message("You've unlocked "+name+"!")
	for x in ceremonies:
		MagicManager.unlocked_ceremonies.append(x)
