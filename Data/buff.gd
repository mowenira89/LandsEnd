class_name Buff extends Resource

enum TYPE {LuckINT,LuckPER,Hunting,Gathering,RSRCH,Scout,BuildingEXP,LongStride,MiningProwess}

var owner
var turns:int=1
@export var type:Dictionary[TYPE,float]

func init(o):
	owner=o

func on_removal():
	pass
	
func end_turn():
	turns+=1
	
func remove():
	on_removal()
	owner.buffs.erase(self)
