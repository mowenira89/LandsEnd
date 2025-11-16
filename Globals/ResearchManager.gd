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
	var t:Territory = b.district.territory if b else u.current_territory
	for x in s.exp_to:
		if research.has(x):
			var r = research[x]
			var num = 1+get_research_buffs(r,b,u)
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
	

func get_research_buffs(research:Research,building:Building=null,unit:Unit=null):
	var array:Array[Buffs]=[]
	var tbs:Buffs
	if building:
		array.append(building.buffs)
		tbs = building.district.territory.buffs
	if unit:
		var buffs = unit.extract_buffs()
		for y in buffs:
			array.append(y)
		if !tbs:
			tbs=unit.current_territory.buffs
	array.append(tbs)
	var r = 0
	for x in array:
		r+=x.get_buffs_total(Buff.TYPE.RSRCH)
	return r
