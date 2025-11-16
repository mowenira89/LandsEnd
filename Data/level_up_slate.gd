class_name LevelUpSlate extends Resource

@export var buildings_unlocked:Array[Building]
@export var upgrades_unlocked:Array[Building]
@export var extentions_unlocked:Array[Building]
@export var extention_slots:int
@export var production_slots:int
@export var buffs:Array[Buff]
@export var trigger_event:Array[Event]

func apply(b:Building):
	for x in buildings_unlocked:
		if x not in GM.unlocked_buildings:
			GM.unlocked_buildings.append(x)
	for x in extentions_unlocked:
		if x not in GM.unlocked_buildings:
			GM.unlocked_buildings.append(x)
	b.production_slots+=production_slots
	b.extention_slots+=extention_slots
	for x in trigger_event:
		GM.add_event(x)
