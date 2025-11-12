class_name Event extends Resource

var turns=1
var effects:Array[Effect]
var id:String
var permanent:bool

func create(id:String, t=1):
	turns = t

func end_turn():
	if !permanent:
		turns-=1
		for x in effects:
			x.per_turn()
			if turns<=0:
				x.apply()
				x.on_removal()

func remove():
	GM.finished_events.append(self)
