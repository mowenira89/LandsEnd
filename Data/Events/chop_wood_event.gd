class_name ChopWoodEvent extends WorkEvent

@export var d:District
@export var wood:float
@export var u:Unit
var lumberjack=0
var strongback=0
var productive=0
var luck=0

func make_plans(p:Population,district:District,unit:Unit=null):
	d=district
	u=unit
	population=p
	workers_needed[Pop.CLASS.Follower]=5
	message = "Chopping Wood"
	if !unit and district.building.boss:	
		lumberjack = d.building.boss.get_prowess(Person.PROWESS.Lumberjack) if !u else u.get_prowess(Person.PROWESS.Lumberjack)
		strongback = d.building_boss.get_prowess(Person.PROWESS.StrongBack) if !u else u.get_prowess(Person.PROWESS.StrongBack)
		productive = d.building_boss.get_prowess(Person.PROWESS.Productive)/10 if !u else u.get_prowess(Person.PROWESS.Productive)/10
		luck = d.building_boss.get_luck() if !u else u.get_luck()
	
func apply():
	
	var max = 2 if d.biome.terrain==Biome.TERRAIN.Forest else 1
	max+=lumberjack+strongback
	var trees = randi_range(1,max)
	trees+=trees*productive
	
	if u:
		u.cargo.add_stuff(RM.stuff["Wood"],trees)
		if RM.stuff["Sandalwood"] in d.biome.flora.keys():
			if randi_range(1,100) < d.biome.flora[RM.species["Sandalwood"]]:
				u.cargo.add_stuff(RM.stuff["Sandalwood"],1+productive,true,d.building,d)
	else:
		d.territory.stockpile.add_stuff(RM.stuff["Wood"],trees)
		if RM.stuff["Sandalwood"] in d.biome.flora.keys():
			if randi_range(1,100) < d.biome.flora[RM.species["Sandalwood"]]:
				d.territory.stockpile.add_stuff(RM.stuff["Sandalwood"],1+productive,true,d.building,d)
	if d.building:
		d.building.get_exp(trees/2)
	
func check_for_accident():
	var base
	if randi_range(1,100-(lumberjack*10))>base+luck:
		if randi_range(1,100-(lumberjack*10))>base+luck:
			var o = u if u else d.building
			man_down(o,Pop.CLASS.Follower,1)
			memory.append('Lost a man chopping wood in '+d.name)
	
