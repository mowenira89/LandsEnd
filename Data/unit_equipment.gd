class_name UnitEquipment extends Stockpile

var unit:Unit

func init(u:Unit):
	unit=u
	capacity=10
	
	
func get_capacity():
	var r = 1
	for x in stuff.keys():
		if x.qualities.has(Stuff.QUALITIES.Capacity):
			r+=x.qualities[Stuff.QUALITIES.Capacity]*stuff[x]
