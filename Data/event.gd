class_name Event extends Resource

var turns=1
var effects:Array[Effect]
var id:String
var message:String

func create(id:String, m:String, t=1):
	turns = t
	message=m

func end_turn():
	turns-=1
	for x in effects:
		x.per_turn(turns)
		if turns<=0:
			x.apply()
			x.on_removal(0)

func is_alive():
	return turns!=0

func get_message()->String:
	return id
	
func get_end_turn_message():
	pass
