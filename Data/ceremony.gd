class_name Ceremony extends Effect

@export var name:String
@export var reward:Dictionary[Stuff,float]
@export var requirements:Dictionary[Stuff,int]
@export var exp_to:Dictionary[Research,float]
@export var tribute:Stockpile
@export var value:float
@export var target:Nymphoi

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
	
		
