class_name Building extends Resource

@export var name:String
@export var district:District
@export var unlocked:bool=false
@export var upgrade_only:bool=false
@export var buffs:Buffs
@export var stats:Stats
@export var image:Texture2D
@export var pop_cap:Dictionary[Pop.CLASS,int]
@export var boss:Person
@export var boss_type:Pop.CLASS
@export var unlock_message:String
@export var age:int=0
@export var memories:Array[Memory]
#CONSTRUCTION

@export var construction_time:int
@export var construction_materials:Dictionary[Stuff,int]
@export var construction_level:int
@export var construction_conditions:Array[Condition]
#STAFF
@export var staff_needed:Dictionary[Pop.CLASS,int]
@export var staff_appointed:Dictionary[Pop.CLASS,int]

#Districts
var utilized_districts:Array[District]
@export var needed_districts:int
@export var district_type:District.TYPES

#Production
@export var production_slots:int
var producing_this_turn=[null,null,null,null,null,null]
var turns_producing=[0,0,0,0,0,0]
@export var recipes:Array[Recipe]
var this_building_recipes:Dictionary[String,Recipe]

#Extentions
@export var possible_extentions:Array[Building]
@export var possible_upgrades:Array[Building]
var extentions = [null,null,null,null,null,null]
var extention_construction = [0,0,0,0,0,0]
var extention_slots:int=0
var extention_buffs:Array[Buff]

#UPGRADES

var upgrade_construction = 0
var upgrading_to:Building
@export var upgrades:Array[Building]
@export var upgrade_at_level:int=0


#EXPERIENCE
var experience:float=0
var level:int=1
@export var level_up_slates:Array[LevelUpSlate]

func create(d:District):
	district=d
	for x in recipes:
		this_building_recipes[x.name]=x
	if !stats:
		stats = Stats.new()
		stats.create(self,construction_level*50,0,0,0)
	else:
		stats.total_hp=construction_level*50
		stats.current_hp=construction_level*50
		

func get_menu():
	GM.menus.basic_building_view.update_menu(self)


func set_production(s:String,i:int,r:Recipe=null):
	if s=="Craft":
		if r==producing_this_turn[i]:
			return
		else:
			producing_this_turn[i]=r
			turns_producing[i]=0
	else:
		producing_this_turn[i]=s
		turns_producing[i]=0

	
func progress_production():
	for x in producing_this_turn.size()-1:
		if producing_this_turn[x] is Recipe:
			var recipe:Recipe = producing_this_turn[x]
			var progress=1
			for y in staff_appointed:
				var percentage=(staff_needed[y]-staff_appointed[y])/100		
				progress*=percentage
			
			turns_producing[x]+=progress
			if turns_producing[x]==recipe.turns:
				turns_producing[x]=0
				for y in recipe.outputs:
					district.territory.stockpile.add_stuff(y,recipe.outputs[y])
				for y in recipe.exp_to:
					ResearchManager.research
				
func repair():
	if stats.current_hp<stats.total_hp:
		var d = {}
		for x in construction_materials:
			if x.qualities.has(Stuff.QUALITIES.Build):
				d[x]=d.qualitites[Stuff.QUALITIES.Build]
		var hp = (stats.total_hp-stats.current_hp)/100
		for x in d:
			d[x]*=hp
		

func end_turn():
	progress_production()
	for x in memories.duplicate():
		x.end_turn()
	age+=1
	
func add_memory(m:Memory):
	memories.append(m)
	m.init()
	
func extract_products():
	var r = []
	for x in this_building_recipes.values():
		for y in x.outputs:
			for z in x.outputs.keys():
				r.append(z)
	var d = {}
	for x in r:
		if x not in d.keys():
			d[x]=1
		else:
			d[x]+=1
			
	return d
	
	
func plunder(stockpile:Stockpile):
	var loot_table = LootTable.new()
	var loot = loot_table.create(extract_products())


func upgrade(b:Building):
	name=b.name
	production_slots=b.production_slots
	extention_slots=b.extention_slots
	for x in b.recipes:
		this_building_recipes[x.name]=x
	image=b.image
	b=null
	
func get_extention(b:Building):
	for x in b.recipes:
		this_building_recipes[x.name]=x
	stats.total_hp+=b.stats.total_hp/2
	stats.current_hp=stats.total_hp
	stats.defense+=b.stats.defense
	stats.offense+=b.offense
	for x in b.staff_needed:
		if x in staff_needed.keys():	
			staff_needed[x]+=b.staff_needed[x]
		else:
			staff_needed[x]=b.staff_needed[x]
			
func take_damage(a:int):
	a+=a*stats.defense/100
	stats.change_hp(a)
	if stats.current_hp<=0:
		destroy_building()
	
func destroy_building(burn:bool=false):
	if !burn:
		for x in construction_materials:
			district.territory.stockpile.add_stuff(x,construction_materials[x]/2)
	district.building=null
	
func get_exp(a:float):
	var b = []
	var mod=0
	for x in buffs.buffs:
		if x is BuildingExpBuff:
			b.append(x)
	for x in boss.personal_buffs.buffs:
		if x is BuildingExpBuff:
			b.append(x)
	for x in district.territory.buffs.buffs:
		if x is BuildingExpBuff:
			b.apped(x)
	for x in b:
		mod+=x.amt
	a+=a*mod
	experience+=a		
	
	
func level_up():
	pass
