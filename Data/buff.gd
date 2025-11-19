class_name Buff extends Resource

enum TYPE {LuckINT,LuckPER,Hunting,Gathering,RSRCH,Scout,BuildingEXP,
Attractiveness}

var stat:Stats.STATS
var amt:int
var owner
var turns:int=1
@export var type:Dictionary[TYPE,float]

func init(o):
	owner=o

func on_removal():
	pass
	
func end_turn():
	if turns>0:
		turns-=1
	if turns==0:
		remove()	
func remove():
	on_removal()
	owner.buffs.erase(self)
