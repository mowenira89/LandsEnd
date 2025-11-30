class_name Event extends Resource

var turns=1
var id:String
var memory:Array[String]
var remember_for:int=-1
var message:String

func create(t=1):	
	turns = t
	
func init():
	pass

func check(d:District=null,t:Territory=null,b:Building=null,u:Unit=null):
	return true

func apply():
	pass
	
func on_removal(turns_left:int=0):
	pass

func per_turn(turns):
	pass

func end_turn():
	per_turn(turns)
	if turns>0:
		turns-=1
		if turns==0:
			apply()
			on_removal()
	if turns < 0:
		apply()
	if remember_for>0:
		remember_for-=1

func is_alive():
	return turns!=0

func get_message()->String:
	return message

func get_memory()->Array[String]:
	return memory
	
func get_end_turn_message():
	pass


func man_down(owner,c:Pop.CLASS,a:int):
	if owner is Building:
		owner.district.territory.population.change_pop(c,a)
	else:
		owner.followers.change_pop(c,a)
