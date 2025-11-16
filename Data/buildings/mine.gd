class_name Mine extends Building

@export var mining:Stuff
var mine_depth:int
var sheave_wheel:bool=false
var water_pump:bool=false
var sideways=0
var disrepair:float=0

func end_turn():
	var haul = 0
	var r = randi_range(1,mining.qualities[Stuff.QUALITIES.Mineable])
	var luck = GM.get_buffs(Buff.TYPE.LuckPER,self,district.territory,boss.unit)
	if mine_depth>0:
		var l=randi_range(1,r)
		l+=l*luck
		haul+=l
		if mine_depth<15:
			mine_depth+=1
	if mine_depth>15:
		if sheave_wheel:
			var l=randi_range(1,r)
			l+=l*luck
			haul+=l		
	if mine_depth>50:
		if water_pump:
			var l=randi_range(1,r)
			l+=l*luck
			haul+=l		
	district.territory.stockpile.add_stuff(mining,haul)


func repair():
	pass
