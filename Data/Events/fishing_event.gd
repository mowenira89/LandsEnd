class_name FishingEvent extends WorkEvent

var district:District
var unit:Unit
var stockpile:Stockpile

func make_plans(p:Population,d:District=null,u:Unit=null):
	district=d
	unit=u
	population=p
	stockpile = unit.cargo if u else d.territory.stockpile
	message = "Fishing"
	workers_needed[Pop.CLASS.Follower]=3
	
func apply():
	var fish = district.biome.fish
	var loot_table = LootTable.new()
	
	var luck=0
	var prowess=1
	if unit:
		luck = unit.get_prowess(Person.PROWESS.Lucky)*10
		prowess += unit.get_prowess(Person.PROWESS.Angler)
	elif district.building:
		if district.building.boss:
			luck+=district.building.boss.get_prowess(Person.PROWESS.Lucky)*10
			prowess+=district.building.boss.get_prowess(Person.PROWESS.Angler)
	loot_table.create(fish,luck)
	for x in prowess:
		var target = loot_table.roll()
		if target is Species:
			for s in target.kill_produce:
				var amt = randi_range(1,target.kill_produce[s])
				stockpile.add_stuff(s,amt,true,district.building,district)	
	if district.building:
		district.building.get_exp(1)
