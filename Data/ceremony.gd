class_name Ceremony extends Effect

@export var name:String
@export var length:int
@export var interest:float
@export var reward:Dictionary[Stuff,float]
@export var happiness_reward:float
@export var person_reward:Dictionary[Person,float]
@export var requirements:Dictionary[Stuff,float]
@export var requirements_of_quality:Dictionary[Stuff.QUALITIES,float]
@export var requirements_of_people:Dictionary[Pop.CLASS,int]
@export var monks_needed:int
@export var exp_to:Dictionary[Research,float]
@export var tribute:Stockpile
@export var value:float
@export var target:Nymphoi
@export var performers=Population

#X amount of people want to attend, causing the requirements to go up

func create(t:Stockpile):
	tribute=t
	

func apply():
	var value = 0
	var stuff = tribute.get_of_quality(Stuff.QUALITIES.Sacred)
	var plus=0
	for x in stuff.values():
		value+=x.get_sacred()*10
		target.credit+=value
		plus+=x.get_luxury()/100
		value+=x.value/4
	value+=value*plus
	var happiness = target.beliefs.stats[Beliefs.STATS.Happiness]
	happiness+=happiness*(value/1000)
	
		
