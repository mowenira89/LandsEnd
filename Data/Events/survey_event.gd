class_name SurveyEvent extends WorkEvent

@export var district:District
@export var unit:Unit
@export var prowess:int


func make_plans(p:Population,d,u=null):
	district=d
	unit=u
	population=p
	prowess = unit.get_prowess(Person.PROWESS.LongStrider) if unit else 1
	message="Surveying "+d.name
	workers_needed[Pop.CLASS.Follower]=2

func apply():
	if unit and unit.followers.get_pops(Pop.CLASS.Follower)<workers_needed[Pop.CLASS.Follower]: prowess=1
	if prowess>0:
		for x in district.territory.districts:
			survey(x)
	else:
		survey(district)

func survey(d:District):
	var loot_table = LootTable.new()
	for x in prowess:
		var target = loot_table.create(d.biome.fauna)
		if target:
			d.fauna_spotted(target)
		target = loot_table.create(d.biome.flora)
		if target:
			d.flora_spotted(target)
		target = loot_table.create(d.biome.forage)
		if target:
			d.forage_spotted(target)
		if district.biome.mineable:
			d.resource_spotted(district.biome.mineable)
			
	if prowess>=3:
		for x in d.biome.fauna:
			d.fauna_spotted(x)
		for x in d.biome.flora:
			d.flora_spotted(x)
		d.resource_spotted(d.biome.mineable)
		for x in d.biome.forage:
			d.forage_spotted(x)
