class_name SurveyEvent extends Event

@export var district:District
@export var unit:Unit
@export var prowess:int


func make_plans(d,u=null):
	district=d
	unit=u
	prowess = unit.get_prowess(Person.PROWESS.LongStrider) if unit else 0
	message="Surveying "+d.name

func apply():
	if prowess>0:
		for x in district.territory.districts:
			survey(x)
	else:
		survey(district)

func survey(d:District):
	var loot_table = LootTable.new()
	for x in prowess:
		var target = loot_table.create(d.biome.fauna)
		print(target)
		d.fauna_spotted(target)
		target = loot_table.create(d.biome.flora)
		d.flora_spotted(target)
	if prowess>=3:
		for x in d.biome.fauna:
			d.fauna_spotted(x)
		for x in d.biome.flora:
			d.flora_spotted(x)
		for x in d.biome.mineable:
			d.resource_spotted(x)
		for x in d.biome.forage:
			d.forage_spotted(x)
