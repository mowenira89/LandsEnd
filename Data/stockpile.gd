class_name Stockpile extends Resource

var stuff:Dictionary[Stuff,float]
var owner

var food_order:Array[Stuff]
var storeroom_order:Array[Stuff]
var animal_order:Array[Species]

var prohibited:Array[Stuff]

var granary_capacity:int=0:get=get_granary_capacity
var storeroom_capacity:int=0:get=get_store_capacity
var animal_fields:int=0:get=get_animal_fields

var outfit : Array[Stuff]=[]

func create(t:Territory=null,unit:Unit=null):
	if t:
		owner=t
		storeroom_capacity=100
		granary_capacity=100
		animal_fields=100
	elif unit:
		owner=unit
		storeroom_capacity=10
		granary_capacity=10
		animal_fields=10
		
func get_store_capacity():
	var c = storeroom_capacity
	for x in outfit:
		if x and x.qualitites.has(Stuff.QUALITIES.Capacity):
			c+=x.qualitites[Stuff.QUALITIES.Capacity]
	if owner is Unit:
		c+=owner.get_prowess(Person.PROWESS.StrongBack)*10
	return c
	
func get_animal_fields():
	var f = animal_fields
	if owner is Unit:
		f+=owner.get_prowess(Person.PROWESS.Shepherd)*100
	return f
	
func get_granary_capacity():
	var c = granary_capacity
	for x in outfit:
		if x and x.qualitites.has(Stuff.QUALITIES.Capacity):
			c+=x.qualitites[Stuff.QUALITIES.Capacity]
	if owner is Unit:
		c+=owner.get_prowess(Person.PROWESS.StrongBack)*10
	return c
		
func add_stuff(s:Stuff,a:float,experience:bool=false):
	
	var cap
	if s in food_order:
		cap=granary_capacity
	elif s is Species:
		cap=animal_fields
	else:
		cap=storeroom_capacity
	if stuff.has(s):
		if stuff[s]+a>cap:
			return false
		else:
			stuff[s]+=a
			return true
	else:
		if a>cap:
			return false
	if s not in stuff.keys():
		print('not in keys')
		if s.qualities.has(Stuff.QUALITIES.Food) and s not in food_order:
			food_order.append(s)
		elif s is Species and s not in animal_order:
			if s.kind!=Species.KIND.Flora:
				animal_order.append(s)
		else:
			storeroom_order.append(s)
		stuff[s]=clamp(a,0,cap)
	if experience:
		if owner is Territory:
			ResearchManager.exp_from_stuff(s,owner,null)
		else:
			ResearchManager.exp_from_stuff(s,null,owner)
	
	
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

func end_turn():
	pass
	if RM.species["Mice"] in stuff.keys():
		if RM.species["Cat"] in stuff.keys():
			return false
		else:
			if RM.stuff["Grain"] in stuff.keys():
				remove_stuff(RM.stuff["Grain"],1)
		
func alter_useage(x:Stuff):
	if x in prohibited:
		prohibited.erase(x)
	else:
		prohibited.append(x)

func add_max(s:Stuff,a:float):
	var cap
	if s in food_order:
		cap=granary_capacity
	elif s is Species:
		cap=animal_fields
	else:
		cap=storeroom_capacity
	if s not in stuff.keys():
		stuff[s]=min(a,cap)
	else:
		stuff[s]=min(stuff[s]+a,cap)
