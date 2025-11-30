class_name Herd extends Resource

var individuals:int
var temperment:float
var hunger:float
var food:Stuff
var species:Species
var name
var stats
var health
var current_health

func create(s:Species,i:int):
	individuals = i
	species=s
	temperment = 0-species.aggressiveness
	species=s.duplicate()
	species.init()	
	name=species.name
	stats=species.stats
	health=species.stats.hp
	current_health=species.stats.hp

func handle(d:District,b:Person):
	hunger+=float(individuals)*species.food_need
	var wrangler=0
	var farmer=0
	var luck=0
	if b:
		wrangler = b.get_prowess(Person.PROWESS.Wrangler)
		farmer = b.get_prowess(Person.PROWESS.Farmer)
		luck=b.get_stat(Stats.STATS.Luck)
		
	eat(d.territory.stockpile)	
	
	if temperment<0:
		if randf_range(0,species.aggressiveness)>wrangler+farmer+1:
			GM.menus.end_turn_box.get_message("Farmers attacked by "+species.name+" at "+d.name+" farm in "+d.territory.name+"!")
		else:
			if GM.month in species.harvest_season:
				for x in species.harvest_produce:
					d.territory.stockpile.add_stuff(x,species.harvest_produce[x]*(individuals/10),true,d.building)
					temperment+=.5
					
func eat(s:Stockpile):
	if !food:
		temperment-=.5
		var damage = health*.05	
		if species.diet==Species.DIET.Carnivore:
			health-=damage
		elif GM.month in [GM.MONTHS.DREAMTIME,GM.MONTHS.FIMBUL,GM.MONTHS.THAWBRAWN]:
			stats.health-=damage
		if health<=0:
			individuals-=floor(individuals*.5)
			current_health=health*.5
		hunger-=10
		return false
	var amt = hunger/food.qualities[Stuff.QUALITIES.Food]
	var amount_to_consume = min(amt,s.stuff[food])
	print(amount_to_consume)
	if s.remove_stuff(food,amount_to_consume):
		species.stats.change_hp(1)
		temperment+=1
		hunger-=food.get_quality(Stuff.QUALITIES.Food)*amount_to_consume
		
