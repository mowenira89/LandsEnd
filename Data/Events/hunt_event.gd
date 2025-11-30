class_name HuntEvent extends WorkEvent


@export var capacity:int
@export var prowess:float=1
@export var local:bool=true
@export var stockpile:Stockpile
@export var territory:Territory
var game_caught:int=0
var owner
var luck
var unit:Unit
var length:int
var district:District
var building:Building
var chief
var efficiency:float=1

func make_plans(pop:Population,b:Building=null,u:Unit=null,d:District=null):
	unit=u
	building=b
	population=pop
	stockpile= u.cargo if u else b.district.territory.stockpile
	territory=b.district.territory if b else u.current_territory
	district=b.district if b else d
	owner=u if u else b
	var ls=0
	var p=0
	if owner is Unit:
		ls=owner.get_prowess(Person.PROWESS.LongStrider)
		p=owner.get_prowess(Person.PROWESS.Hunter)
		
		luck=owner.get_prowess(Person.PROWESS.Lucky)
	if owner is Building:
		if owner.boss:
			ls=owner.boss.get_prowess(Person.PROWESS.LongStrider)
			p=owner.boss.get_prowess(Person.PROWESS.Hunter)
			luck=owner.boss.get_prowess(owner.boss)
	length += ls
	prowess+=p
	message="Hunting in "+district.name
	workers_needed[Pop.CLASS.Follower]=5
	
func apply():
	
	if population.get_pops(Pop.CLASS.Follower)<workers_needed[Pop.CLASS.Follower]:
		efficiency=.5

	
	hunt(district)
	var t=null
	if length>1:
		
		if owner is Building:
			t=owner.district.territory
		elif owner is Unit:
			t=owner.current_territory
			
		var potential_districts = []
		for x in t.districts:
			if x.type==0:
				potential_districts.append(x)
		for x in length:
			hunt(potential_districts.pick_random())
	GM.animals_killed+=game_caught
	
	ResearchManager.research["Archery"].add_exp(game_caught/2,building,unit,district)

func hunt(d:District):
	var game = d.biome.get_game()
	var prohibited = owner.prohibited_game
	for x in prohibited:
		if x in game:
			game.erase(x)
		
	if unit is Unit:
		luck = unit.get_stat(Stats.STATS.Luck)
		luck=max(10,luck)
	elif building and building.boss:
		luck=building.boss.get_stat(Stats.STATS.Luck)
	else:
		luck=1
	var loot_table = LootTable.new()
	loot_table.create(game,luck)
	var target = loot_table.roll()
	if target:
		d.fauna_spotted(target)
		var r = randi()%100
		if r<target.skittishness*10-luck:
			if 100-luck>prowess*10:
				if randi_range(0,10)+3+prowess<target.stats.speed*10:
					memory.append("Spotted a "+target.name+" but it escaped.")
					return false
				elif randi_range(1,100)-luck>target.aggressiveness*10*efficiency:
					if target.aggressiveness>target.skittishness:
						if target.aggressiveness>prowess*efficiency: 
							if randf_range(0,100-target.stats.offense*10)>(randi_range(1,100)-luck)*efficiency:
								man_down(owner, Pop.CLASS.Follower,1)
								memory.append("Lost a man to a "+target.name+"!")
								return false
						else:
							if luck+3<target.stats.speed:
								memory.append("Spotted a "+target.name+" but it escaped.")
								return false
						
		if !prowess>target.stats.defense:
			if target.aggressiveness>(prowess+luck)*efficiency:
				if randi_range(1,prowess*10)-luck>randf_range(0,100-target.stats.offense*10)*efficiency:
					man_down(owner, Pop.CLASS.Follower,1)
					memory.append("Lost a man to a "+target.name+"!")
					
					return false
					
		for x in target.kill_produce:
			var amt = randi_range(1,target.kill_produce[x])
			stockpile.add_stuff(x,amt,true,building,district)
		game_caught+=1
		memory.append("Successfully hunted a "+target.name+"!")
		
		 
