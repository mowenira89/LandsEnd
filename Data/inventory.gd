class_name Inventory extends Resource


@export var weapon:Stuff
@export var armor:Stuff
@export var steed:Species

var owner:Person

func init(o):
	owner=o

func get_stats(s:Stats.STATS):
	var r = 0
	match s:
		Stats.STATS.HP:
			if weapon:
				r+=weapon.stats.total_hp
			if armor:
				r+=armor.stats.total_hp
		Stats.STATS.Attack:	
			if weapon:		
				r+=weapon.stats.offense
			if armor:
				r+=armor.stats.offense
			if steed:
				r+=steed.stats.offense
		Stats.STATS.Defense:
			if weapon:
				r+=weapon.stats.defense
			if armor:
				r+=armor.stats.defense
		Stats.STATS.Magic:
			if weapon:
				r+=weapon.stats.magic
			if armor:
				r+=armor.stats.magic
		Stats.STATS.MagicDef:
			if weapon:
				r+=weapon.stats.magic_def
			if armor:
				r+=armor.stats.magic_def
		Stats.STATS.MagicDef:
			if weapon:
				r+=weapon.stats.magic_def
			if armor:
				r+=armor.stats.magic_def
		Stats.STATS.Speed:
			if weapon:
				r+=weapon.stats.speed
			if armor:
				r+=armor.stats.speed
			if steed:
				r+=steed.stats.speed
		Stats.STATS.Luck:
			if weapon:
				r+=weapon.stats.luck
			if armor:
				r+=armor.stats.luck
			if steed:
				r+=steed.stats.luck
	return r
