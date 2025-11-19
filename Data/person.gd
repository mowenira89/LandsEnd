class_name Person extends Resource

enum PROWESS {Hunter,Gathering,Fishing,Trading,Farming,Smithing,Woodsmith,MiningSavant,
GreenThumb,LongStrider,Wise,Lucky,Fortunate,StrongBack,Shepherd}


@export var title:String
@export var name:String
@export var age:int
@export var species:Species
@export var image:Texture2D
@export var abilities:Array[Ability]
@export var prowess:Dictionary[PROWESS,float]
@export var level:int
@export var stats:Stats
@export var CLASS:Pop.CLASS
@export var beliefs:Beliefs
@export var beliefs_mods:Dictionary[Beliefs.STATS,float]
@export var presence_buffs:Buffs
@export var personal_buffs:Buffs
@export var territorial_prowess:Dictionary[PROWESS,float]
@export var current_territory:Territory
@export var unit:Unit
@export var unlocked:bool=false
@export var inventory:UnitInventory
@export var memories:Array[Event]
@export var friend:bool=true
@export var ally:bool=false
@export var behavior:Behavior


const ICON = "uid://dxqvaehqg2uoa"


func create(t:Territory,k:Species):
	name=""
	species=k
	image=load(ICON)
	inventory=UnitInventory.new()
	inventory.init(self)
	beliefs=t.population.pops[CLASS].beliefs.duplicate()
	for x in beliefs_mods:
		beliefs.change_stat(x,beliefs_mods[x])	
	current_territory=t
	current_territory.NPCs.append(self)
	if !presence_buffs:
		presence_buffs = Buffs.new()
	if !personal_buffs:
		personal_buffs = Buffs.new()
	stats=Stats.new()
	stats.init(self)
	stats.stats[Stats.STATS.HP]=species.stats.hp
	stats.stats[Stats.STATS.Attack]=species.stats.off
	stats.stats[Stats.STATS.Defense]=species.stats.def
	stats.stats[Stats.STATS.Magic]=species.stats.mag
	stats.stats[Stats.STATS.MagicDef]=species.stats.magdef
	stats.stats[Stats.STATS.Speed]=species.stats.sp
	stats.stats[Stats.STATS.Luck]=species.stats.l
	

func move(t:Territory):
	if current_territory:
		for x in presence_buffs.buffs:
			current_territory.buffs.buffs.erase(x)
		current_territory.NPCs.erase(self)
	current_territory=t
	current_territory.NPCs.append(self)
	for x in presence_buffs.buffs:
		current_territory.buffs.add_buff(x)

func get_personal_buff_total(t:Buff.TYPE):
	return personal_buffs.get_buffs_total(t)


func get_prowess(p:PROWESS):
	if prowess.has(p):
		return prowess[p]
	return 0
		
func add_memory(e:Event):
	memories.append(e)

func end_turn():
	pass
