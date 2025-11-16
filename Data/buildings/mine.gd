class_name Mine extends Building

@export var mining:Stuff
var mine_depth:int=1
var sheave_wheel:bool=false
var water_pump:bool=false
var sideways=0
var disrepair:float=0
@export var max_depth:int

func end_turn():
	var haul = 0
	var r = randi_range(1,mining.qualities[Stuff.QUALITIES.Mineable])
	var luck = GM.get_buffs(Buff.TYPE.LuckPER,self,district.territory,boss.unit)
	var l=randi_range(1,r)
	l+=l*luck
	haul+=l
	sideways+=1
	if mine_depth<50:
		mine_depth+=1
	if mine_depth>15:
		if water_pump:
			l=randi_range(1,r)
			l+=l*luck
			haul+=l		
	if mine_depth>200:
		if sheave_wheel:
			l=randi_range(1,r)
			l+=l*luck
			haul+=l		
	district.territory.stockpile.add_stuff(mining,haul)


func repair():
	pass

func get_damage(depth:int):
	var r = randi_range(1,100)
	var prowess = 10+GM.get_prowess(Person.PROWESS.Mining,self)*10
	var mod = GM.get_buffs(Buff.TYPE.MiningProwess,self,district.territory,boss.leader)
	prowess+=mod
	if r>prowess:
		var damage = randi_range(1,r)
		var memory = Memory.new()
		var string = str(damage)+" damage done in collapse."
		memory.create(self,damage,string)
