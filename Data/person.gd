class_name Person extends Resource

enum PROWESS {Hunter,Trader,Farmer,Smith,Woodsmith,Miner,
GreenThumb,LongStrider,Wise,Lucky,Fortunate,StrongBack,Shepherd,Spear,Sword,Mage,
Marksmen,Productive,Lumberjack,Angler,Ranger,Preacher,Wrangler,Maverick,
KeenEye,Shield,Rider,Artillery,Archer,Teacher,Alchemist,Metallurgist}

enum RARITY {Common,Rare,Epic,Legendary,Unique}

const MILITARY_PROWESS = [PROWESS.Spear,PROWESS.Sword,PROWESS.Mage,PROWESS.Marksmen,
PROWESS.Shield,PROWESS.Rider,PROWESS.Artillery,PROWESS.Archer]

@export var title:String
@export var name:String
@export var age:int
@export var birth_month:GM.MONTHS
@export_range(1,4) var birth_week:int
var alive=true
@export var species:Species
@export var image:Texture2D
@export var abilities:Array[Ability]
@export var prowess:Dictionary[PROWESS,float]
@export var level:int
@export var stats:Stats
@export var CLASS:Pop.CLASS
@export var beliefs:Beliefs
@export var beliefs_mods:Dictionary[Beliefs.STATS,float]
@export var stat_mods:Dictionary[Stats.STATS,float]
@export var current_territory:Territory
@export var past_territories:Array[Territory]
var unit:Unit
var boss_of:Building
var in_building:Building
@export var unlocked:bool=false
@export var inventory:Inventory
@export var memories:Array[Event]
@export var behavior:Behavior
@export var affinity:Array[Stuff.MYSTIC]
@export var knowledge:Array[Research]
var experience:int
var unique:bool=false
@export var recipes:Array[Recipe]
@export var ceremonies:Array[Ceremony]
var id:String
var learning:Dictionary[PROWESS,float]
@export var lectures:Array[Lecture]
@export var lectures_completed:Array[Lecture]

@export var known_spells:Array[Spell]
var learning_spells:Dictionary[Spell,float]

var battle_index:int=-1

var stat_weights = {
	Stats.STATS.Attack:1.0,
	Stats.STATS.Defense:.5,
	Stats.STATS.Magic:1.0,
	Stats.STATS.MagicDef:.5,
	Stats.STATS.Speed:.2,
	Stats.STATS.Luck:.5,
	Stats.STATS.HP:.1
}

const ICON = "uid://dxqvaehqg2uoa"


func create(t:Territory,k:Species,friendliness:float,a:int):
	name=""
	
	species=k
	image=load(ICON)
	if !inventory:
		inventory=Inventory.new()
	else:
		if inventory.weapon:
			inventory.weapon.stats.init(inventory.weapon)
		if inventory.armor:
			inventory.armor.stats.init(inventory.armor)
		if inventory.steed:
			inventory.steed.stats.init(inventory.steed)
	inventory.init(self)
	beliefs=t.population.pops[CLASS].beliefs.duplicate()
	for x in beliefs_mods:
		beliefs.change_stat(x,beliefs_mods[x])	
	current_territory=t
	current_territory.NPCs.append(self)
	if !stats:
		stats=Stats.new()
		stats.init(self)
		stats.stats[Stats.STATS.HP]=species.stats.hp+randi_range(0,10)
		stats.stats[Stats.STATS.CurrentHP]=stats.stats[Stats.STATS.HP]
		stats.stats[Stats.STATS.Attack]=species.stats.off+randf_range(-1,1)
		stats.stats[Stats.STATS.Defense]=species.stats.def+randf_range(-1,1)
		stats.stats[Stats.STATS.Magic]=species.stats.mag+randf_range(-1,1)
		stats.stats[Stats.STATS.MagicDef]=species.stats.magdef+randf_range(-1,1)
		stats.stats[Stats.STATS.Speed]=species.stats.sp+randf_range(-1,1.5)
		stats.stats[Stats.STATS.Luck]=species.stats.l+randf_range(-2,2)
	for x in stat_mods:
		stats.stats[x]+=stat_mods[x]
	beliefs.stats[Beliefs.STATS.Loyalty]=friendliness
	age=a
	birth_month=GM.month
	birth_week=GM.week
	id = species.name+"_"+name+"_"+str(randi_range(1,10000))
	for x in species.knowledge:
		if x not in knowledge:
			knowledge.append(x)
	for x in species.natural_prowess:
		if x not in prowess:
			prowess[x]=species.natural_prowess[x]
		else:
			prowess[x]+=species.natural_prowess[x]

		
		
func move(t:Territory):
	if current_territory:
		if current_territory not in past_territories:
			past_territories.append(current_territory)
		current_territory.NPCs.erase(self)
	current_territory=t
	current_territory.NPCs.append(self)


func get_prowess(p:PROWESS):
	var r = 0
	if prowess.has(p):
		r += prowess[p]
	if inventory.armor and inventory.armor.conveys_prowess.has(p):
		r+=inventory.armor.conveys_prowess[p]
	if inventory.weapon and inventory.weapon.conveys_prowess.has(p):
		r+=inventory.weapon.conveys_prowess[p]
	if inventory.steed and inventory.steed.conveys_prowess.has(p):
		r+=inventory.steed.conveys_prowess[p]
	return r
		
func add_memory(e:Event):
	memories.append(e)

func end_turn():
	pass

func get_stat(stat:Stats.STATS):
	var r = 0
	match stat:
		Stats.STATS.HP:
			r=inventory.get_stats(stat)
			r+=stats.total_hp
		Stats.STATS.Attack:
			r=inventory.get_stats(stat)
			r+=stats.offense
		Stats.STATS.Defense:
			r=inventory.get_stats(stat)
			r+=stats.defense
		Stats.STATS.Magic:
			r=inventory.get_stats(stat)
			r+=stats.magic
		Stats.STATS.MagicDef:
			r=inventory.get_stats(stat)
			r+=stats.magic_def
		Stats.STATS.Speed:
			r=inventory.get_stats(stat)
			r+=stats.speed
		Stats.STATS.Luck:
			r=inventory.get_stats(stat)
			r+=stats.luck
			if prowess.has(Person.PROWESS.Lucky):
				r+=prowess[Person.PROWESS.Lucky]*1.5
	return r

func equip_weapon(s:Stuff,inventory:Stockpile):
	if inventory.weapon:
		inventory.add_stuff(inventory.weapon,1)
	inventory.remove_stuff(s,1)	
	inventory.weapon=s
	
func equip_armor(s:Stuff,inventory:Stockpile):
	if inventory.armor:
		inventory.add_stuff(inventory.armor,1)
	inventory.remove_stuff(s,1)
	inventory.armor=s

func equip_steed(s:Stuff,inventory:Stockpile):
	if inventory.steed:
		inventory.add_stuff(inventory.steed,1)
	inventory.remove_stuff(s,1)
	inventory.steed=s

func learn(p:PROWESS,a:float,l:Lecture=null):
	if a==0:
		learning[p]=0
		return
	if p not in learning.keys():
		learning[p]=a
	else:
		learning[p]+=a
	var m = (get_prowess(p)+1)*1000
	var r = randf_range(1,m)
	var base = beliefs.stats[Beliefs.STATS.Creativity]*10
	base += get_prowess(PROWESS.Wise)*10
	base+=learning[p]
	if l and l.lecturer:
		base+=(l.lecturer.get_prowess(PROWESS.Wise)*5)+(l.lecturer.get_prowess(PROWESS.Teacher)*5)
	if r<base:
		if prowess.has(p):
			prowess[p]=clamp(prowess[p]+1,0,10)
		else:
			prowess[p]=1
		learning[p]=0	

func get_friendliness():
	if beliefs.stats[Beliefs.STATS.Loyalty]<=-.9:
		return false
	return true

func remove_as_boss():
	if boss_of:
		boss_of.boss=null
		boss_of=null
	in_building=null
	
func join_building(b:Building):
	if unit:
		unit.remove_person(self)
	in_building=b
	
func leave_building():
	in_building=null


func get_all_stats():
	var r = {}
	for x in Stats.STATS.values():
		r[x]=get_stat(x)
	return r

func get_power():
	var s = get_all_stats()
	s.erase(Stats.STATS.CurrentHP)
	for x in s:
		s[x]*=stat_weights[x]
	var power = 0
	for x in s:
		power+=x
	if inventory.weapon is Weapon:
		for x in inventory.weapon.prowess_bonus:
			if x in prowess:
				power+=power*prowess[x]/10
				
			
	return power

func take_damage(a:float):
	stats.change_hp(-a)


func save():
	var d = {}
	d['title']=title
	d['name']=name
	d['species']=species.name
	d['age']=age
	d['prowess']=prowess.duplicate()
	d['level']=level
	d['stats']=stats.stats.duplicate()
	d['class']=CLASS
	d['beliefs']=beliefs.stats.duplicate()
	d['current_territory']=current_territory.coords
	d['inventory']={}
	d['inventory']['weapon'] = null if !inventory.weapon else inventory.weapon.name
	d['inventory']['armor'] = null if !inventory.armor else inventory.armor.name
	d['inventory']['steed'] = null if !inventory.steed else inventory.steed.name
