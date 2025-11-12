class_name Buff extends Resource

var owner

func init(o):
	owner=o

func on_removal():
	pass
	
func remove():
	on_removal()
	owner.buffs.erase(self)
