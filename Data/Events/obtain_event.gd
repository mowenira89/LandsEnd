class_name ObtainEvent extends Event

var district:District
var species:Stuff
var building:Building
var unit:Unit

func make_plans(d:District,s:Stuff,b:Building,u:Unit):
	district = d
	species = s
	building = b
	unit = u
	message = "Obtaining a "+species.name+" in "+district.name

func apply():
	var longstride = 1
	if building:
		if building.boss:
			longstride+=building.boss.get_prowess(Person.PROWESS.LongStrider)
	else:
		longstride+=unit.get_prowess(Person.PROWESS.LongStrider)
	for x in longstride:
		search_and_find()	
				
func search_and_find():
	var keeneye=0
	var hunter=0
	var wrangler=0
	var luck=0
	if unit:
		keeneye=unit.get_prowess(Person.PROWESS.KeenEye)*10
		hunter=unit.get_prowess(Person.PROWESS.Hunter)*10
		wrangler = unit.get_prowess(Person.PROWESS.Wrangler)*10
		luck=unit.get_luck()
	elif building and building.boss:
		keeneye=building.boss.get_prowess(Person.PROWESS.KeenEye)*10
		hunter=building.boss.get_prowess(Person.PROWESS.Hunter)*10
		wrangler = building.boss.get_prowess(Person.PROWESS.Wrangler)*10		
		luck=building.boss.get_stat(Stats.STATS.Luck)
	var rarity
	if species in district.biome.fauna:
		rarity=district.biome.fauna[species]
	elif species in district.biome.flora:
		rarity=district.biome.flora[species]
	if randf_range(1,100)<rarity+keeneye+hunter:
		if randf_range(1,100)+wrangler<species.skittishness:
			GM.menus.end_turn_box.get_message("Spotted a "+species.name+" but it fled!")
		else:
			if wrangler+hunter<species.aggressiveness:
				GM.menus.end_turn_box.get_message("The "+species.name+" attacked!")
			else:
				if randi_range(1,100)+wrangler+hunter>=species.aggressiveness:
					obtain_species()
				else:
					GM.menus.end_turn_box.get_message("Failed to obtain "+species.name)
				
func obtain_species():
	var stockpile:Stockpile
	if unit:
		stockpile=unit.cargo
	else:
		stockpile=building.district.territory.stockpile
	stockpile.add_stuff(species,1)
	GM.menus.end_turn_box.get_message("Obtains a "+species.name+" in "+district.name)
	if species is Crop and species not in GM.unlocked_crops:
		GM.unlocked_crops.append(species)
