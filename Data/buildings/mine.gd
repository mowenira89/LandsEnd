class_name Mine extends Building

@export var mining:Stuff
var mine_depth:int=1
var sheave_wheel:bool=false
var water_pump:bool=false
var y=0
var disrepair:float=0
var max_depth:int=100

func create(d:District):
	super(d)
	y  = randi_range(1,3)

func end_turn():
	
	var haul = 0
	var luck = boss.get_prowess(Person.PROWESS.Lucky) if boss else 0
	var prowess = boss.get_prowess(Person.PROWESS.Miner) if boss else 0
	prowess+=age/100
	haul = y * (1+prowess**.7)*(1 + log(1*mine_depth))
	haul+=haul*luck/10
	
	district.territory.stockpile.add_stuff(mining,haul)
	experience+=1


	var base=.05
	var depth_factor = mine_depth/(mine_depth+5)
	var skill_factor = 1 - (prowess**.8)
	if randf() < base + depth_factor * skill_factor:
		take_damage(10-luck)

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
	var prowess = 10+GM.get_prowess(Person.PROWESS.Miner,self)*10
	var disrepair = stats.total_hp-stats.current_hp
	r+=disrepair
	if r>prowess:
		var damage = randi_range(1,r)
		var memory = Memory.new()
		var string = str(damage)+" damage done in collapse."
		memory.create(self,damage,string)
		memories.append(memory)
		take_damage(damage)

func level_up():
	super()
	max_depth=level*100
