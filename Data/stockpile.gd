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


func create(t:Territory=null,unit:Unit=null,b:Building=null):
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
		outfit.resize(4)
	elif b:
		owner=b
		storeroom_capacity=100
		granary_capacity=100
		animal_fields=10
		
func get_store_capacity():
	var c=0
	if owner is Unit:
		for x in outfit:
			if x and x.qualities.has(Stuff.QUALITIES.Capacity):
				c+=x.qualities[Stuff.QUALITIES.Capacity]	
		c+=owner.get_prowess(Person.PROWESS.StrongBack)*10
		c+=owner.followers.get_total_population()
	elif owner is Territory:
		for x:District in owner.districts:
			if x.building:
				c+=x.building.storeroom_cap
				for y in x.building.extentions:
					if y:
						c+=y.storeroom_cap
	elif owner is Building:
		c+=owner.storeroom_cap
		for x in owner.extentions:
			c+=x.storeroom_cap
	return c
	
func get_animal_fields():
	var f = 10
	if owner is Unit:
		f+=owner.get_prowess(Person.PROWESS.Shepherd)*100+owner.get_prowess(Person.PROWESS.Wrangler)
	elif owner is Territory:
		f+=10
		for x in owner.districts:
			if x.building:
				f+=x.building.animal_fields
	return f
	
func get_granary_capacity():
	var c=0
	if owner is Unit:
		for x in owner.cargo.outfit:
			if x and x.qualities.has(Stuff.QUALITIES.Capacity):
				c+=x.qualities[Stuff.QUALITIES.Capacity]	
		c+=owner.get_prowess(Person.PROWESS.StrongBack)*10
		c+=owner.followers.get_total_population()
	elif owner is Territory:
		for x:District in owner.districts:
			if x.building:
				c+=x.building.granary_cap
				for y in x.building.extentions:
					if y:
						c+=y.granary_cap
	elif owner is Building:
		c+=owner.granary_cap
		for x in owner.extentions:
			c+=x.granary_cap
	return c

		
func add_stuff(s:Stuff,a:float,experience:bool=false,b:Building=null,d:District=null):
	
	var cap=get_capacity(s)
	if stuff.has(s):
		if stuff[s]+a>cap:
			return false
		else:
			stuff[s]+=a
			if experience:
				if owner is Territory:
					ResearchManager.exp_from_stuff(s,b,null,d)
				else:
					ResearchManager.exp_from_stuff(s,b,owner,d)
			return true
	else:
		if a>cap:
			return false
	if s.qualities.has(Stuff.QUALITIES.Food):
		if s not in food_order:
			food_order.append(s)
	elif s is Species and s not in animal_order and s.kind!=Species.KIND.Flora:
		animal_order.append(s)
	elif s not in storeroom_order:
		storeroom_order.append(s)
	stuff[s]=a
	if experience:
		if owner is Territory:
			ResearchManager.exp_from_stuff(s,b,null,d)
		else:
			ResearchManager.exp_from_stuff(s,b,owner,d)
	
	
func remove_stuff(s:Stuff,a:float,experience:bool=false,b:Building=null,d:District=null):
	if !s:
		return false
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
			if experience:
				if owner is Territory:
					ResearchManager.exp_from_stuff(s,b,null,d)
				else:
					ResearchManager.exp_from_stuff(s,b,owner,d)
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

func get_outfit()->Array[Stuff]:
	var r:Array[Stuff] = []
	for x in stuff:
		if x.qualitites.has(Stuff.QUALITIES.Capacity):
			if x not in r:
				r.append(x)
		elif x.qualitites.has(Stuff.QUALITIES.Travel):
			if x not in r:
				r.append(x)
		elif !x.conveys_prowess.is_empty():
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
	if RM.species["Mice"] in stuff.keys():
		if RM.species["Cat"] in stuff.keys():
			pass
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

func get_capacity(s:Stuff):
	if s.qualities.has(Stuff.QUALITIES.Food):
		return get_granary_capacity()
	elif s is Species and s.kind!=Species.KIND.Flora:
		return get_animal_fields()
	else:
		return get_store_capacity()
