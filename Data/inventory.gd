class_name Inventory extends Resource


@export var weapon:Stuff
@export var armor:Stuff
@export var steed:Species

func get_stats(s:Stats.STATS):
	var r = 0
	match s:
		Stats.STATS.HP:
			r+=weapon.stats.total_hp
			r+=armor.stats.total_hp
		Stats.STATS.Attack:			
			r+=weapon.stats.offense
			r+=armor.stats.offense
			r+=steed.stats.offense
		Stats.STATS.Defense:
			r+=weapon.stats.defense
			r+=armor.stats.defense
		Stats.STATS.Magic:
			r+=weapon.stats.magic
			r+=armor.stats.magic
		Stats.STATS.MagicDef:
			r+=weapon.stats.magic_def
			r+=armor.stats.magic_def
		Stats.STATS.MagicDef:
			r+=weapon.stats.magic_def
			r+=armor.stats.magic_def
		Stats.STATS.Speed:
			r+=weapon.stats.speed
			r+=armor.stats.speed
			r+=steed.stats.speed
		Stats.STATS.Luck:
			r+=weapon.stats.luck
			r+=armor.stats.luck
			r+=steed.stats.luck
	return r
