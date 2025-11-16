class_name Stockpile extends Resource

var stuff:Dictionary[Stuff,float]
var capacity:int=100
var owner

var food_order:Array[Food]
var storeroom_order:Array[Stuff]
var animal_order:Array[Species]

var forbidden_food:Array[Food]
var non_consumables:Array[Stuff]

var granary_capacity:int
var storeroom_capacity:int
var animal_fields:int

func add_stuff(s:Stuff,a:float):
	
	var cap
	if s in food_order:
		cap=granary_capacity
	elif s is Species:
		cap=animal_fields
	else:
		cap=granary_capacity
	if stuff.has(s):
		if stuff[s]+a>cap:
			return false
	else:
		if a>cap:
			return false
	if s not in stuff.keys():
		stuff[s]=clamp(a,0,cap)
		if owner is Territory:
			ResearchManager.exp_from_stuff(s,owner,null)
		else:
			ResearchManager.exp_from_stuff(s,null,owner)
	else:
		stuff[s]=clamp(stuff[s]+a,0,cap)
		if owner is Territory:
			ResearchManager.exp_from_stuff(s,owner,null)
		else:
			ResearchManager.exp_from_stuff(s,null,owner)
	if s.qualities.has(Stuff.QUALITIES.Food) and s not in food_order:
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
			if stuff[s]==0:
				stuff.erase(s)
				if s in food_order:
					food_order.erase(s)
				elif s in animal_order:
					animal_order.erase(s)
				else:
					storeroom_order.erase(s)
			return true
	else:
		return false

func check_stuff_amount(s:Stuff):
	if s not in stuff.keys():
		return 0
	else:
		return stuff[s]

func swap_food(a:Stuff,b:Stuff):
	var index_a = food_order.find(a)
	var index_b = food_order.find(b)
	food_order[index_a]=b
	food_order[index_b]=a
	
func swap_storeroom(a:Stuff,b:Stuff):
	var index_a = storeroom_order.find(a)
	var index_b = storeroom_order.find(b)
	storeroom_order[index_a]=b
	storeroom_order[index_b]=a
	

func get_of_quality(q:Stuff.QUALITIES):
	var r={}
	for x in stuff:
		if x.qualities.has(q):
			r[x]=x.qualities.has(q)
	return r

func get_outfit():
	var r = []
	for x in stuff:
		if x.qualitites.has(Stuff.QUALITIES.Capacity):
			if x not in r:
				r.append(x)
		elif x.qualitites.has(Stuff.QUALITIES.Travel):
			if x not in r:
				r.append(x)
	return r

func get_stockpile_owner():
	pass


func get_building_materials():
	var r={}
	for x in stuff.keys():
		if x.qualities.has(Stuff.QUALITIES.Build):
			r[x]=x.qualities[Stuff.QUALITIES.Build]
	return r
