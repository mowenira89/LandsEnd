class_name UnitInventory extends Stockpile

var unit:Unit

func init(u:Unit):
	unit=u
	
	
func get_capacity():
	var r=1
	for x in stuff.keys():
		if x.qualities.has(Stuff.QUALITIES.Capacity):
			r+=x.qualities[Stuff.QUALITIES.Capacity]*stuff[x]
	r+=unit.get_total_followers()
	capacity=r

func add_stuff(s:Stuff,a:float):
	super(s,a)
	
