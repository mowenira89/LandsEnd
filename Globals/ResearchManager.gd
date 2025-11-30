extends Node

var research:Dictionary[String,Research] = {}

func _ready():
	add_research()
	RM.check_exp_to()
	
func add_research():
	var path = "res://Resources/Research/"
	var dir = ResourceLoader.list_directory(path)
	for x in dir:
		var new = load(path+x)
		research[new.name]=new
		print(new.name+" "+str(new.exp_to_unlock))

func exp_from_stuff(s:Stuff,b:Building=null,u:Unit=null,d:District=null):
	for x in s.exp_to:
		ResearchManager.research[x].add_exp(s.exp_to[x],b,u,d)

func get_exp_from_nymphoi(n:Nymphoi):
	var territory = n.unit.current_territory
	var companions = n.unit.companions
	var prowess = n.get_prowess(Person.PROWESS.Wise)
