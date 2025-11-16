class_name HuntEffect extends Effect

@export var capacity:int
@export var prowess:float=1
@export var local:bool=true
@export var stockpile:Stockpile
@export var territory:Territory
@export var district:District
var game_caught:int=0
var owner

func create(s:Stockpile,t:Territory,d:District,o):
	stockpile=s
	territory=t
	district=d
	owner=o
	
	
func apply():
	
	var districts_searched:int=0

	while districts_searched<7:
		if local:
			districts_searched=7
			if district.type==0:
				hunt(owner.district)
		else:
			var ds = district.territory.districts
			for x in ds:
				if x.type==0:
					hunt(x)
				districts_searched+=1
	GM.animals_killed+=game_caught

func hunt(d:District):
	
	var game = d.biome.get_game()
	var prohibited = owner.prohibited_game
	for x in prohibited:
		if x in game:
			game.erase(x)
	
	var t=null
	if owner is Building:
		t=owner.district.territory
	elif owner is Unit:
		t=owner.current_territory

	var b = owner if owner is Building else null
	var o = owner if owner is Unit else null
	var luck = GM.get_buffs(Buff.TYPE.LuckINT,b,t,o)	
	var prowess_mod=GM.get_buffs(Buff.TYPE.Hunting,b,t,o)
	if owner is Unit:
		prowess=owner.get_powess(Person.PROWESS.Hunting)
	elif owner is Building and owner.boss:
		prowess=owner.boss.prowess[Person.PROWESS.Hunting] if owner.boss else 1
	prowess+=prowess*prowess_mod
	var loot_table = LootTable.new()
	var target = loot_table.create(game,luck)
	var memory = ""
	if target:
		d.fauna_spotted(target.name)			
		#Check if spooked
		luck=100-luck
		if luck>prowess*10:
			if randi_range(0,100)>target.speed*10:
				memory+="Spotted a "+target.name+" but it escaped."
				return false
			elif luck>80:
				if target.offense>prowess:
					if randf_range(0,100-target.offense*10)<luck:
						man_down(Pop.CLASS.Follower,1)
						memory+="Lost a man to a "+target.name+"!"
						make_memory(owner,10,memory)
						return false
		if !prowess>target.defense:
			if target.offense>prowess:
				if luck>randf_range(0,100-target.offense*10):
					man_down(Pop.CLASS.Follower,1)
					memory+="Lost a man to a "+target.name+"!"
					make_memory(owner,10,memory)
					return false
					
		for x in target.kill_produce:
			stockpile.add_stuff(x,target.kill_produce[x])
		game_caught+=1
		memory+="Successfully hunted a "+target.name+"!"
		make_memory(owner,10,memory)
		 
			
func man_down(c:Pop.CLASS,a:int):
	if owner is Building:
		owner.district.territory.population.change_pop(c,a)
	else:
		owner.followers.change_pop(c,a)
	#MESSAGE

func make_memory(o,t:int, m:String):
	var memory = Memory.new()
	memory.create(o,t,m)
	o.memories.append(memory)

func get_message():
	return "Hunting"
