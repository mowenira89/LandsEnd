class_name Person extends Resource

enum KEYWORD {Merchant,Farmer,Hunter,Scout}

@export var title:String
@export var name:String
@export var image:Texture2D
@export var abilities:Array[Ability]
@export var keywords:Array[KEYWORD]
@export var level:int
@export var stats:Stats
@export var CLASS:Pop.CLASS
@export var beliefs:Beliefs
@export var beliefs_mods:Dictionary[Beliefs.STATS,float]
@export var presence_buffs:Buffs
@export var personal_buffs:Buffs
@export var current_territory:Territory
@export var unit:Unit
@export var unlocked:bool=false
@export var inventory:UnitInventory

const ICON = "uid://dxqvaehqg2uoa"


func create(t:Territory):
	name=""
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

func end_turn():
	pass
