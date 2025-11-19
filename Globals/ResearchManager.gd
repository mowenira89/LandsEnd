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

func exp_from_stuff(s:Stuff,b:Building=null,u:Unit=null):
	var t = b.district.territory if b else u.current_territory
	var wisdom
	if b and b.boss:
		wisdom=b.boss.get_prowess(Person.PROWESS.Wise)
	elif u:
		wisdom=u.get_powess(Person.PROWESS.Wise)
		
	
	for x in s.exp_to:
		if research.has(x):
			var r = research[x]
			var num = s.exp_to[x]+wisdom
			research[x].add_exp(s.exp_to[x],num,t)

func exp_from_recipe(a:int,b:Building):
	var array:Array[Buffs]=[]
	array.append(b.buffs)	
	if b.boss:
		array.append(b.boss.personal_buffs)
	array.append(b.district.territory.buffs)
	var r=0
	for x in array:
		r+=x.get_buffs_total(Buff.TYPE.RSRCH)
	

func get_exp_from_nymphoi(n:Nymphoi):
	var territory = n.unit.current_territory
	var companions = n.unit.companions
	var prowess = n.get_prowess(Person.PROWESS.Wise)
