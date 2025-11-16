class_name SurveyEffect extends Effect

@export var district:District
@export var person:Person
@export var prowess:int

func create(d:District,p:Person=null):
	district=d	
	person=p

func apply():
	if person:
		if person.personal_buffs.any(func(x):return x is ScoutBuff):
			for x in district.territory.districts:
				survey(x)
		else:
			survey(district)
	else:
		survey(district)

func survey(d:District):
	var loot_table = LootTable.new()
	for x in prowess:
		var target = loot_table.create(d.biome.fauna)
		d.fauna_spotted(target)
		target = loot_table.create(d.biome.flora)
		d.flora_spotted(target)
	
	for x in d.biome.fauna:
		d.fauna_spotted(x)
	for x in d.biome.flora:
		d.flora_spotted(x)
	for x in d.biome.mineable:
		d.resource_spotted(x)
	for x in d.biome.forage:
		d.forage_spotted(x)

func get_message():
	if person.presence_buffs.any(func(x):return x is ScoutBuff):
		return "Surveying "
