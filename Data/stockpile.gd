class_name Stockpile extends Resource

var stuff:Dictionary[Stuff,float]
var capacity:int=100

var food_order:Array[Food]
var storeroom_order:Array[Stuff]
var animal_order:Array[Species]

var forbidden_food:Array[Food]
var non_consumables:Array[Stuff]



func add_stuff(s:Stuff,a:float):
	if s not in stuff.keys():
		stuff[s]=a
	else:
		stuff[s]=clamp(stuff[s]+a,0,capacity)
	if s is Food and s not in food_order:
		food_order.append(s)
	elif s is Species and s not in animal_order:
		if s.kind!=Species.KIND.Flora:
			animal_order.append(s)
	else:
		storeroom_order.append(s)
	
func remove_stuff(s:Stuff,a:float):
	if s in stuff.keys():
		if stuff[s]-a<0:
			return false
		else:
			stuff[s]-=a
	else:
		return false

func check_stuff_amount(s:Stuff):
	if s not in stuff.keys():
		return 0
	else:
		return stuff[s]

func get_food():
	var r = []
	for x in stuff:
		if x is Food:
			r.append(x)
	return r
