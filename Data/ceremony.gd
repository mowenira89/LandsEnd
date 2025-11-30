class_name Ceremony extends Event

@export var name:String
@export var length:int
@export var interest:float
@export var reward:Dictionary[Stuff,float]
@export var happiness_reward:float
@export var person_reward:Dictionary[Person,float]
@export var requirements:Dictionary[Stuff,float]
@export var requirements_of_quality:Dictionary[Stuff.QUALITIES,float]
@export var requirements_of_people:Dictionary[Pop.CLASS,int]
@export var exp_to:Dictionary[Research,float]
@export var credit_to:Dictionary[Stuff.MYSTIC,float]
@export var events:Array[Event]
@export var convey_spell:Dictionary[Spell,float]
@export var sanctity:float
var tribute:Dictionary[Stuff,int]
var value:float
var target:Nymphoi
var performers:Array[Person]
var leader:Person
@export var unlocked:bool=false


var provisions = {
	Stuff.QUALITIES.Fuel:null,
	Stuff.QUALITIES.Incense:null,
	"offering":null,
	"target":null,
	"priest":null,
	Stuff.QUALITIES.Instrument:null,
	Stuff.QUALITIES.Libation:null,
}


var stockpile:Stockpile
var happiness_boost=0
var insult:float=0
var offering:Stuff
var favor:int=0
var population:Population
var successful_days:int=0

var building:Temple

func make_plans(t:Dictionary,p:Population,s:Stockpile,b:Temple=null):
	provisions=t
	stockpile=s
	population=p
	building=b
	message="Conducting "+name

func init():
	for x in requirements_of_people:
		population.change_temp_jobs(x,requirements_of_people[x])

func on_removal(turns:int=0):
	for x in requirements_of_people:
		population.change_temp_jobs(x,-requirements_of_people[x])
	if turns>0:
		target.insult+=insult+turns

func per_turn(turn):
	var fuel = provisions[Stuff.QUALITIES.Fuel]
	
	if !stockpile.remove_stuff(fuel,1):
		insult+=5
		happiness_boost-=.1
		return false
		
	value+=1
	if fuel.qualities.has(Stuff.QUALITIES.Incense):
		var v=fuel.qualities[Stuff.QUALITIES.Incense]
		if v>0:
			value+=v*10
		else:
			if name != "Flying Mushroom Ceremony":
				if Stuff.MYSTIC.Eldrich in target.affinity:
					value+=v*-10
				else:
					value+=v*10
					insult+=1
				happiness_reward-=.1
		
			
	for x in requirements:
		if stockpile.remove_stuff(x,requirements[x]):
			value += x.value
			value+=x.get_quality(Stuff.QUALITIES.Sacred)*10
			if x in target.favorites:
				happiness_boost+=.2
			for y in x.mystic_qualities:
				if y in target.affinity:
					value+=x.mystic_qualities[y]*100
		else:
			happiness_boost-=.5
			insult+=1
	
	for x in requirements_of_quality:
		if !provisions[x]:
			insult+=1
		else:
			var amt = ceil(requirements_of_quality[x]/provisions[x].qualities[x])
			var all=true
			if stockpile.remove_stuff(provisions[x],amt,true):
				value+=provisions[x].get_quality(x)*10
				value+=provisions[x].get_quality(Stuff.QUALITIES.Sacred)*10
				happiness_boost+=((provisions[x].get_quality(x)/10)+(provisions[x].get_quality(Stuff.QUALITIES.Luxury)/10))/2
			else:
				all=false
				insult+=.5
			if all:
				successful_days+=1

	for x in provisions:
		if x is int and x not in requirements_of_quality:
			if provisions[x] and stockpile.remove_stuff(provisions[x],1):
				value+=(provisions[x].get_quality(x)*10)+provisions[x].get_quality(Stuff.QUALITIES.Sacred)*10
				if x == Stuff.QUALITIES.Libation and provisions[x]:
					var boost=provisions[x].get_quality(Stuff.QUALITIES.Libation)/10
					happiness_reward+=happiness_reward*boost
					value+=provisions[x].get_quality(x)*10
					value+=provisions[x].get_quality(Stuff.QUALITIES.Sacred)*10
		if x=="offering":
			var v = 0
			for y in provisions["offering"][0].mystic_qualities:
				if y in target.affinity:
					v+=provisions["offering"][0].mystic_qualitie[y]*provisions["offering"][1]

func apply():
	target.get_credit(value)
	target.beliefs.change_stat(Beliefs.STATS.Happiness,happiness_boost)
	target.insult+=insult
	target.favor+=favor

	if MagicManager.ceremonies_performed.has(name):
		MagicManager.ceremonies_performed[name]+=1
	else:
		MagicManager.ceremonies_performed[name]=1
