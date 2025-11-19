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
	var stockpile = district.territory.stockpile
	var percentage = (stats.total_hp-stats.current_hp)/100
	var materials_needed = construction_materials.duplicate()
	for x in materials_needed.keys():
		if !x.qualities.has(Stuff.QUALITIES.Build):
			materials_needed.erase(x)
	for x in materials_needed:
		materials_needed[x]*=percentage
		if stockpile.check_stuff_amount(x)<materials_needed[x]:
			return false
	for x in materials_needed:
		stockpile.remove_stuff(x,materials_needed[x])
	stats.current_hp=stats.total_hp
			

func get_damage(depth:int):
	var r = randi_range(1,100)
	var prowess = 10+GM.get_prowess(Person.PROWESS.MiningSavant,self)*10
	var disrepair = stats.total_hp-stats.current_hp
	r+=disrepair
	if r>prowess:
		var damage = randi_range(1,r)
		var memory = Memory.new()
		var string = str(damage)+" damage done in collapse."
		memory.create(self,damage,string)
		memories.append(memory)
		take_damage(damage)
