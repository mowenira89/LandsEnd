class_name ForageEvent extends WorkEvent

var territory:Territory
var building:Building
var stockpile:Stockpile
var district:District
var unit:Unit
var capacity = 1
var local:bool=true
var length:int=1
var luck:int=1
var obtained=0

func make_plans(p:Population,b:Building=null,u:Unit=null,d:District=null):
	stockpile=u.cargo if u else b.district.territory.stockpile
	territory = u.current_territory if u else b.district.territory
	building=b
	district=d if d else b.district
	unit=u
	population=p
	workers_needed[Pop.CLASS.Follower]=3
	message = "Foraging in "+territory.name
	if b and b.boss:
		var longstrider = b.boss.get_prowess(Person.PROWESS.LongStrider)
		if longstrider:
			length+=longstrider
	elif u:
		var longstrider = u.leader.get_prowess(Person.PROWESS.LongStrider)
		length+=longstrider*2
		
	
	if unit:
		luck = unit.get_prowess(Person.PROWESS.Lucky)
		capacity = unit.get_prowess(Person.PROWESS.Ranger) 
		if capacity==0: capacity=1
	elif building:
		if building.boss:
			luck = building.boss.get_prowess(Person.PROWESS.Lucky)
			capacity = building.boss.get_prowess(Person.PROWESS.Ranger) if building.boss else 1 
	else:
		luck=0
		capacity=1

	

func apply():
	
	if population.get_pops(Pop.CLASS.Follower)<workers_needed[Pop.CLASS.Follower]:
		capacity*=.5
	
	var haul = []
	var potential_districts:Array[District]=[]
	var loot = _forage(district)
	if loot:
		haul.append(loot)
	if length>1:
		for x in length:
			potential_districts.append(territory.districts.pick_random())	
		for x in length:
			var haul2 = _forage(potential_districts.pick_random())
			if haul2:
				haul.append(haul2)
	for x:Stuff in haul:
		stockpile.add_stuff(x,1,true,building,district)
		if !x.exp_to.is_empty():
			for y in x.exp_to:
				ResearchManager.research[y].add_exp(x.exp_to[y],building,unit,district)
		if building:
			building.get_exp(obtained)
		GM.menus.end_turn_box.get_message("Foraged "+x.name+" in "+district.name)
	if haul.is_empty():
		GM.menus.end_turn_box.get_message("Found nothing in "+district.name)
	
func _forage(d:District):
	var loot_table = LootTable.new()
	var possible_forage = d.biome.forage.duplicate()
	for x in possible_forage.keys():
		if x is Crop and GM.month not in x.harvest_season:
			possible_forage.erase(x)
	loot_table.create(possible_forage,luck)
	var forage = loot_table.roll() 
	if forage is Stuff:
		obtained+=1
		d.forage_spotted(forage)
		if randi_range(1,100)<luck:
			var spotted = loot_table.create(d.biome.fauna)
			d.fauna_spotted(spotted)
	return forage
	
