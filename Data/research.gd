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

func add_exp(a:float,b:Array[Buffs],territory:Territory):
	for x in conditions:
		if !x.check(null,territory):
			return false
	for x in prerequisites:
		if !ResearchManager.research[x.name].unlocked:
				return false
		var amt = add_buffs(a,b)
		
		current_exp+=amt
		if current_exp>=exp_to_unlock:
			check_inspiration(territory)
			
func check_inspiration(t:Territory):
	var creativity = t.population.get_pop_belief(inspired_class,Beliefs.STATS.Creativity)
	
func unlock():
	for x in buildings:
		RM.buildings[x.name].unlocked=true
	for x in people:
		RM.NPCs[x.name].unlocked=true
	for x in recipes:
		RM.recipes[x.id].unlocked=true

func add_buffs(a:float,bs:Array[Buffs]):
	var rbs:Array[ResearchBuff] = []
	for x in bs:
		var y = x.get_research_buffs()
		for z in y:
			if z not in rbs: 
				rbs.append(z)
	for x in rbs:
		if !x.research.is_empty():
			if self in x.research:
				a+=x.amount
		else:
			a+=x.amount
	return a
