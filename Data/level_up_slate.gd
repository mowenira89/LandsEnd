class_name LevelUpSlate extends Resource

@export var extentions_unlocked:Array[Building]
@export var upgrades_unlocked:Array[Building]
@export var extention_slots:int
@export var production_slots:int
@export var buffs:Array[Buff]
@export var trigger_event:Array[Event]
@export var needs_upgrade:Array[Building]
@export var needs_extentions:Array[Building]
@export var needs_districts:int
@export var district_upgrade:Array[District.TYPES]
@export var store_cap_up:int
@export var granary_cap_up:int
@export var animal_fields_up:int
@export var pops_cap_up:Dictionary[Pop.CLASS,int]
@export var attractiveness_boost:float
@export_multiline var unlock_message:String

func check(b:Building):
	if b.districts_assigned.size()<needs_districts:
		return false
	for x in needs_extentions:
		if x not in b.extentions:
			return false
	for x in needs_upgrade:
		if b.name==x.name:
			return true
	if !needs_upgrade.is_empty():
		return false
	return true
	

func apply(b:Building):
	for x in extentions_unlocked:
		if x not in GM.unlocked_buildings:
			GM.unlocked_buildings.append(x)
		if x not in b.possible_extentions:
			b.possible_extentions.append(x)
	for x in upgrades_unlocked:
		if x not in GM.unlocked_buildings:
			GM.unlocked_buildings.append(x)
		if x not in b.possible_upgrades:
			b.possible_upgrades.append(x)
	b.production_slots+=production_slots
	b.extention_slots+=extention_slots
	for x in pops_cap_up:
		b.pop_cap[x]+=pops_cap_up[x]
	b.storeroom_cap+=store_cap_up
	b.granary_cap+=granary_cap_up
	b.animal_fields+=animal_fields_up
	for x in trigger_event:
		GM.add_event(x)
