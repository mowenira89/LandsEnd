class_name Stats extends Resource


var owner

signal death

@export var hp:float
@export var off:float
@export var def:float
@export var mag:float
@export var magdef:float
@export var sp:float
@export var l:float

enum STATS {HP,CurrentHP,Attack,Defense,Speed,Luck,Magic,MagicDef} 

var stats:Dictionary[STATS,float] = {}

var current_hp:float=0: get=get_hp
var total_hp:float=0:get=get_total_hp
var offense:float=0:get=get_offense
var defense:float=0:get=get_defense
var luck:float=0:get=get_luck
var magic:float=0:get=get_magic
var magic_def:float=0:get=get_magic_def
var speed:float=0:get=get_speed

var buffs:Buffs

func init(o):
	stats[STATS.HP]=hp
	stats[STATS.CurrentHP]=hp
	stats[STATS.Attack]=off
	stats[STATS.Defense]=def
	stats[STATS.Magic]=mag
	stats[STATS.MagicDef]=magdef
	stats[STATS.Speed]=sp
	stats[STATS.Luck]=l
	owner=o
	buffs=Buffs.new()
	buffs.create(o)


func get_hp():
	current_hp = stats[STATS.CurrentHP]
	return current_hp
	
func get_total_hp():
	total_hp=stats[STATS.HP]
	var mod=0
	for x in buffs.return_buff_amount(STATS.HP):
		if x.stat==stats[STATS.HP]:
			mod+=x.amt
	total_hp+=total_hp*mod	
	return total_hp
	
func get_offense():
	offense=stats[STATS.Attack]
	var mod=0
	for x in buffs.return_buff_amount(STATS.Attack):
		if x.stat==stats[STATS.Attack]:
			mod+=x.amt
	total_hp+=total_hp*mod
	return offense

func get_defense():
	defense=stats[STATS.Defense]
	var mod=0
	for x in buffs.return_buff_amount(STATS.Defense):
		if x.stat==stats[STATS.Defense]:
			mod+=x.amt
	total_hp+=total_hp*mod
	return defense
	
func get_luck():
	luck=stats[STATS.Luck]
	var mod=0
	for x in buffs.return_buff_amount(STATS.Luck):
		if x.stat==stats[STATS.Luck]:
			mod+=x.amt
	total_hp+=total_hp*mod
	return luck
	
func get_magic():
	magic=stats[STATS.Magic]
	var mod=0
	for x in buffs.return_buff_amount(STATS.Magic):
		if x.stat==stats[STATS.Magic]:
			mod+=x.amt
	total_hp+=total_hp*mod
	return magic
	
func get_magic_def():
	magic_def=stats[STATS.MagicDef]
	var mod=0
	for x in buffs.return_buff_amount(STATS.MagicDef):
		if x.stat==stats[STATS.MagicDef]:
			mod+=x.amt
	total_hp+=total_hp*mod
	return magic_def
	
func get_speed():
	speed=stats[STATS.Speed]
	var mod=0
	for x in buffs.return_buff_amount(STATS.Speed):
		if x.stat==stats[STATS.Speed]:
			mod+=x.amt
	total_hp+=total_hp*mod
	return speed

func create(o,h:float,of:float,d:float,s:float,lu:float):
	owner=o
	stats[STATS.HP]=h
	stats[STATS.CurrentHP]=h
	stats[STATS.Attack]=of
	stats[STATS.Defense]=d
	stats[STATS.Speed]=s
	stats[STATS.Luck]=lu
	
	
func change_hp(a:float):
	stats[STATS.CurrentHP]=clamp(stats[STATS.CurrentHP]+a,0,stats[STATS.HP])
	if stats[STATS.CurrentHP]==0:
		die()
		
func die():
	if owner is Person:
		GM.afterlife[owner]=0
		if owner.unit:
			owner.unit.remove_person(owner)
		owner.remove_as_boss()
		owner.current_territory.NPCs.erase(owner)
		owner.alive=false			
	death.emit(owner)
