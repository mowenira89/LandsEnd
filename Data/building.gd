class_name Building extends Resource

@export var name:String
@export var district:District
@export var unlocked:bool=false
@export var buffs:Array[Buff]
@export var hp:float
@export var image:Texture2D
@export var pop_cap:Dictionary[Pop.CLASS,int]

#CONSTRUCTION

@export var construction_time:int
@export var construction_materials:Dictionary[Stuff,int]
@export var construction_staff:Dictionary[Pop.CLASS,int]
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
var upgrade_level:int=1
var upgrade_construction = 0

#EXPERIENCE
var experience:float=0
var level:int=1
@export var level_up_slates:Array[LevelUpSlate]
func create(d:District):
	district=d
	for x in recipes:
		this_building_recipes[x.name]=x
	hp=construction_level*50
