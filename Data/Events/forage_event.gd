class_name ForageEvent extends Event

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

func make_plans(t:Territory,s:Stockpile,d:District,b:Building=null,u:Unit=null):
	territory=t
	stockpile=s
	building=b
	district=d
	unit=u
	message = "Foraging in "+t.name
	if b and b.boss:
		var longstrider = b.boss.get_prowess(Person.PROWESS.LongStrider)
		if longstrider:
			length+=longstrider*2
	elif u:
		var longstrider = u.leader.get_prowess(Person.PROWESS.LongStrider)
		length+=longstrider
		
	var l
	if unit:
		l = unit.get_powess(Person.PROWESS.Lucky)
	elif building:
		if building.boss:
			l = building.boss.get_prowess(Person.PROWESS.Lucky)
	luck=l
	if building and building.boss:
		capacity = building.boss.get_prowess(Person.PROWESS.Gathering) if building.boss else 1 
	elif unit:
		var c = unit.get_powess(Person.PROWESS.Gathering) 
		capacity = c if c else 1
	

func apply():
	var haul = []
	var potential_districts:Array[District]=[]
	haul.append(forage(district))
	if length>1:
		for x in length:
			potential_districts.append(territory.districts.pick_random())	
	for x in length:
		haul.append(forage(potential_districts.pick_random()))
	for x in haul:
		stockpile.add_stuff(x,1,true)
	
func forage(d:District):
	var loot_table = LootTable.new()
	var forage = loot_table.create(d.biome.forage,luck)
	if forage is Stuff:
		if stockpile.add_stuff(forage,1*capacity,true):
			obtained+=1
		if forage not in d.discovered_forage:
			d.discovered_forage.append(forage)
			memory+="Discovered "+forage.name+" in "+d.name+"\n"
		if randi_range(1,100)<luck:
			var spotted = loot_table.create(d.biome.fauna)
			d.fauna_spotted(spotted)
			memory+="Spotted a "+d.name+"!\n"
	return forage
	
func get_message():
	return "Foraging"

func create_memory(m:String):
	pass
