class_name GatherEffect extends Effect

var territory:Territory
var district:District
var building:Building
var stockpile:Stockpile
var unit:Unit
var capacity = 1

func create(d:District,s:Stockpile,b:Building=null,u:Unit=null):
	district=d
	stockpile=s
	building=b
	unit=u

		

func apply():
	var districts_gathered=0
	var potential_districts:Array[District]=[]
	var obtained=0	
	var luck = GM.get_buffs(Buff.TYPE.LuckINT,building,building.district.territory,unit)
	
	if building:
		capacity = building.boss.get_prowess(Person.PROWESS.Gathering) if building.boss else 1 
	elif unit:
		capacity = unit.get_powess(Person.PROWESS.Gathering)	
	capacity += GM.get_buffs(Buff.TYPE.Gathering,building,building.district.territory,unit)
	
	var memory = ""
	for x in territory.districts:
		if x.type==0:
			potential_districts.append(x)
	for x in potential_districts:
		var loot_table = LootTable.new()
		var forage = loot_table.create(x.biome.forage,luck)
		if forage is Stuff:
			stockpile.add_stuff(forage,1)
			obtained+=1
			if forage not in x.discovered_forage:
				x.discovered_forage.append(forage)
				memory+="Discovered "+forage.name+" in "+x.name+"\n"
			if randi_range(1,100)<luck:
				var spotted = loot_table.create(x.biome.fauna)
				x.fauna_spotted(spotted)
				memory+="Spotted a "+x.name+"!\n"
			ResearchManager.exp_from_stuff(forage,building,unit)
			if obtained>=capacity:
				
				return
	
func get_message():
	return "Foraging"

func create_memory(m:String):
	var memory = Memory.new()
	var owner = building if building else unit
	memory.create(owner,5,m)
	owner.memories.apped(memory)
