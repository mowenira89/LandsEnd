class_name WoodEvent extends Event

var district:District
var stockpile:Stockpile
var unit:Unit

func make_plans(d:District,s:Stockpile,u:Unit=null):
	district=d
	stockpile=s
	unit=u
	
func apply():
	pass
