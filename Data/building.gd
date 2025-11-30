class_name Building extends Resource

@export var name:String
@export var district:District
@export var unlocked:bool=false
@export var upgrade_only:bool=false
@export var stats:Stats
@export var image:Texture2D
@export var pop_cap:Dictionary[Pop.CLASS,int]
var boss:Person
@export var boss_type:Pop.CLASS
@export var unlock_message:String
var age:int=0
var memories:Array[Event]
@export_multiline var desc:String
@export var potential_npcs:Dictionary[Person,float]
#CONSTRUCTION
var blursed:Dictionary[Nymphoi.BLURSES,float]
@export var construction_time:int
@export var construction_materials:Dictionary[Stuff,int]
@export var construction_level:int
@export var construction_conditions:Array[Condition]
#STAFF
@export var staff_needed:Dictionary[Pop.CLASS,int]
var staff_appointed:Dictionary[Pop.CLASS,float]

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
@export var extention_slots:int=0
var extention_construction_order:Array[Building]
#UPGRADES

var upgrade_construction = 0
var upgrading_to:Building
@export var upgrades:Array[Building]
@export var upgrade_at_level:int=0


#EXPERIENCE

var experience:float=0
@export var level:int=1
@export var level_up_slates:LevelUpSlates


@export var granary_cap:int
@export var storeroom_cap:int
@export var animal_fields:int
@export var attractiveness_boost:float

func create(d:District):
	district=d
	for x in recipes:
		this_building_recipes[x.name]=x
	if !stats:
		stats = Stats.new()
		stats.create(self,construction_level*50,0,0,0,0)
	else:
		stats.total_hp=construction_level*50
		stats.current_hp=construction_level*50
	for x in Pop.CLASS.values():
		staff_appointed[x]=0
	stats.init(self)

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

func get_production(i:int):
	var prod = producing_this_turn[i]
	if prod:
		if prod is Recipe:
			return prod.name
		else:
			return prod.name

func get_production_options():
	pass
	
func progress_production():
	for x in producing_this_turn.size()-1:
		if producing_this_turn[x] is Recipe:
			var recipe:Recipe = producing_this_turn[x]
			var progress=1
			for y in staff_needed:
				var percentage=clamp(float(staff_needed[y])/staff_appointed[y],0,1)
				progress*=percentage
			
			turns_producing[x]+=progress
			if turns_producing[x]==recipe.turns:
				turns_producing[x]=0
				var proceed = true 
				for y in recipe.inputs:
					if district.territory.stockpile.check_stuff_amount(y)<recipe.inputs[y]:
						proceed = false
						break
				if !proceed:
					continue
				else:
					
					if !check_special():
						continue
					
					for y in recipe.inputs:
						district.territory.stockpile.remove_stuff(y,recipe.inputs[y],true,self,district)
					for y in recipe.outputs:
						
						var amt = recipe.outputs[y]
						var percentage=0
						if boss:
							percentage+=boss.get_prowess(Person.PROWESS.Productive)/10
							#ADD BLESSING HERE
							amt+=amt*percentage
						district.territory.stockpile.add_stuff(y,amt)
					for y in recipe.exp_to:
						ResearchManager.research[y].add_exp(recipe.exp_to[y],self)
					district.biome.air_pollution+=recipe.air_pollution
					district.biome.water_pollution+=recipe.water_pollution
					district.biome.spiritual_pollution+=recipe.spiritual_pollution		
					get_exp(recipe.exp_value)
				
				
func check_special()->bool:
	return true
				
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
	level_up_slates=b.level_up_slates.duplicate()
	for x in b.recipes:
		this_building_recipes[x.name]=x
	image=b.image
	for x in b.possible_extentions:
		possible_extentions.append(x)
	for x in b.staff_needed:
		if x in staff_needed.keys():	
			staff_needed[x]+=b.staff_needed[x]
		else:
			staff_needed[x]=b.staff_needed[x]
	
func get_extention(b:Building):
	for x in b.recipes:
		this_building_recipes[x.name]=x
	stats.total_hp+=(b.construction_level*50)/2
	if b.stats:
		stats.current_hp=stats.total_hp
		stats.defense+=b.stats.defense
		stats.offense+=b.offense
		stats.magic+=b.stats.magic
		stats.magdef+=b.stats.magdef
		stats.luck+=b.stats.luck
	for x in b.staff_needed:
		if x in staff_needed.keys():	
			staff_needed[x]+=b.staff_needed[x]
		else:
			staff_needed[x]=b.staff_needed[x]
			
func take_damage(a:float):
	a-=a*stats.defense/10
	stats.change_hp(a)
	if stats.current_hp<=0:
		destroy_building()
	
func destroy_building(burn:bool=false):
	if !burn:
		for x in construction_materials:
			district.territory.stockpile.add_stuff(x,construction_materials[x]/2)
	if pop_cap:
		for x in pop_cap:
			var pop = district.territory.get_pop(x)
			var cap = district.territory.get_pop_cap(x)-pop_cap[x]
			var loss = max(pop-cap,0)
			district.territory.population.change_pop(x,-loss)
			district.territory.population.change_pop(Pop.CLASS.Underclass,loss)
	district.building=null
	
func get_exp(a:float):
	var wisdom=0
	if boss:
		wisdom=boss.get_prowess(Person.PROWESS.Wise)
	experience+=a+wisdom
	if experience>=(level+1)*(50**2):
		level_up()		
	
	
func level_up():
	var level_up_slate = level_up_slates.slates[level+1]
	if level_up_slate.check(self):
		level_up_slate.apply(self)
		level+=1
		experience=0

func save():
	var s = get_save()
	return s

func get_save():
	var s = {}
	s["building_type"]=name
	s["index"]=district.index
	s["boss"]=null if !boss else boss.id
	s["territory"]=district.territory.coords
	s["stats"] = stats.stats.duplicate()
	s["district"]=district.index
	s["age"]=age
	s["utilized_districts"]=[]
	for x in utilized_districts:
		s.utilized_districts.append(x.index)
	s["producing_this_turn"]=[]
	s["turns_producing"]=turns_producing.duplicate()
	for x in producing_this_turn:
		if x is Recipe:
			s["producing_this_turn"].append(x.name)
		else:
			s["producing_this_turn"].append(x)
	s["this_building_recipes"]=[]
	for x in this_building_recipes.values():
		s["this_building_recipies"].append(x.id)
	s["extentions"]=[]
	for x in extentions:
		if x:
			s["extentions"].append(x.name)
		else:
			s["extentions"].append(null)
	s["extention_construction"] = extention_construction.duplicate()
	s["extention_slots"] = extention_slots
	
	s["upgrade_construction"] = upgrade_construction
	s["upgrading_to"] = upgrading_to.name
	s["experience"]=experience
	s["level"]=level
	s["potential_npcs"]={}
	for x in potential_npcs.keys():
		s["potential_npcs"][x.id]=potential_npcs[x]
	return s
	
