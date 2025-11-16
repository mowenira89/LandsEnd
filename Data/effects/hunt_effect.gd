class_name HuntEffect extends Effect

@export var building:Building
@export var capacity:int
@export var prowess:float=1
@export var local:bool=true
@export var stockpile:Stockpile
@export var unit:Unit
var game_caught:int=0

func create(s:Stockpile,u:Unit=null,b:Building=null):
	building=b
	stockpile=s
	unit=u

func apply():
	
	var districts_searched:int=0

	while districts_searched<7:
		if local:
			districts_searched=7
			if building.district.type==0:
				hunt(building.district)
		else:
			var ds = building.district.territory.districts
			for x in ds:
				if x.type==0:
					hunt(x)
				districts_searched+=1
	GM.animals_killed+=game_caught

func hunt(d:District):
	
	var game = d.biome.get_game()
	for x in building.prohibited_game:
		if x in game:
			game.erase(x)
	
	var t=null
	if building:
		t=building.district.territory
	elif unit:
		t=unit.current_territory

	
	var luck = GM.get_buffs(Buff.TYPE.LuckINT,building,t,unit)	
	var prowess_mod=GM.get_buffs(Buff.TYPE.Hunting,building,t,unit)
	prowess+=prowess*prowess_mod
	var loot_table = LootTable.new()
	var target = loot_table.create(game,luck)
	
	if target:
		d.fauna_spotted(target.name)			
		#Check if spooked
		luck=100-luck
		if luck>prowess*10:
			if randi_range(0,100)>target.speed*10:
				return false
			elif luck>80:
				if target.offense>prowess:
					if randf_range(0,100-target.offense*10)<luck:
						man_down(Pop.CLASS.Follower,1)
		if !prowess>target.defense:
			if target.offense>prowess:
				if luck>randf_range(0,100-target.offense*10):
					man_down(Pop.CLASS.Follower,1)
					return false
		for x in target.kill_produce:
			stockpile.add_stuff(x,target.kill_produce[x])
		game_caught+=1
	
func man_down(c:Pop.CLASS,a:int):
	building.district.territory.population.change_pop(c,a)
	#MESSAGE

func get_message():
	return "Hunting"
