class_name Population extends Resource

var pops:Dictionary[Pop.CLASS,Pop]
var territory:Territory

var hunger:float
var vitamins:Dictionary[Biome.VITAMINS,int]

func create(t:Territory):
	territory=t
	for x in Pop.CLASS.values():
		var new_pop = Pop.new()
		new_pop.create(x,t)

func get_total_population():
	var r=0
	for x in pops.values():
		r+=x.persons
	return r

func consume():
	if hunger>0:
		for x in territory.stockpile.food_order:
			while hunger>0:
				pass
				
func assimilate_unit(u:Unit,mode:String):
	var followers = u.followers.pops
	for x in followers:
		var cap = territory.get_pop_cap(x)
		var current_pop = pops[x].persons
		var change=0
		if followers[x].persons>cap-current_pop:
			change = cap-current_pop
		else:
			change=followers[x].persons
		for b in followers[x].beliefs.stats:
			var num = ((followers[x].beliefs[b]*followers[x].persons)+(pops[x].beliefs[b]*pops[x].persons))/(followers[x].persons+pops[x].persons)
			followers[x].beliefs.stats[b]=num
			
		followers[x].persons-=change
		pops[x].persons+=change
		
		if followers[x].persons>0 and mode=="Disband":
			pops[Pop.CLASS.Underclass].persons+=followers[x].persons
		
		
	
			
