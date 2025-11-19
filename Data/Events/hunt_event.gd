class_name HuntEvent extends Event


@export var capacity:int
@export var prowess:float=1
@export var local:bool=true
@export var stockpile:Stockpile
@export var territory:Territory
var game_caught:int=0
var owner
var luck
var unit
var length:int
var district:District

func make_plans(d:District,s:Stockpile,t:Territory,o):
	stockpile=s
	territory=t
	owner=o
	district=d
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
	
	
func apply():
	hunt(district)
	if length>1:
		var t=null
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

func hunt(d:District):
	var game = d.biome.get_game()
	var prohibited = owner.prohibited_game
	for x in prohibited:
		if x in game:
			game.erase(x)
	
	var u = owner.boss if owner is Building else owner
		
	if u is Unit:
		
		luck=max(10,luck*10)
	else:
		luck=10
	var loot_table = LootTable.new()
	var target = loot_table.create(game,luck)
	if target:
		d.fauna_spotted(target)
		var r = randi()%100
		if r<target.skittishness*10-luck:
			if 100-luck>prowess*10:
				if randi_range(0,10)+3+prowess<target.stats.speed*10:
					memory+="Spotted a "+target.name+" but it escaped."
					return false
				elif randi_range(1,100)-luck>target.aggressiveness*10:
					if target.aggressiveness>target.skittishness:
						if target.aggressiveness>prowess: 
							if randf_range(0,100-target.stats.offense*10)>randi_range(1,100)-luck:
								man_down(Pop.CLASS.Follower,1)
								memory+="Lost a man to a "+target.name+"!"
								return false
						else:
							if luck+3<target.stats.speed:
								memory+="Spotted a "+target.name+" but it escaped."
								return false
						
		if !prowess>target.stats.defense:
			if target.aggressiveness>prowess+luck:
				if randi_range(1,prowess*10)-luck>randf_range(0,100-target.offense*10):
					man_down(Pop.CLASS.Follower,1)
					memory+="Lost a man to a "+target.name+"!"
					
					return false
					
		for x in target.kill_produce:
			var amt = randi_range(1,target.kill_produce[x])
			stockpile.add_stuff(x,amt)
		game_caught+=1
		memory+="Successfully hunted a "+target.name+"!"
		
		 
			
func man_down(c:Pop.CLASS,a:int):
	if owner is Building:
		owner.district.territory.population.change_pop(c,a)
	else:
		owner.followers.change_pop(c,a)
	#MESSAGE
