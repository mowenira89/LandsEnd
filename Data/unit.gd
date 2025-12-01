class_name Unit extends Resource

var name:String
var leader:Person
var cargo:Stockpile
var outfit:Array[Stuff]
var followers:Population
var action_queue:Array[Event]=[]
var original_territory:Territory
var previous_territory:Territory
var current_territory:Territory
var destination_territory:Territory
var companions:Array[Person]=[]
var guard:Array[MilitaryUnit]=[]
var speed:int=1
var movements_allowed_this_turn=0
var traveling:bool=false
var friendly:bool=true
var memories:Array[Memory]
var prohibited_game:Array[Species]
#STATS
var animals_killed:int=0
var previous_territories:Array[Territory]
var turns_existed:int=0
var creation_date=[]
var automate:bool=false
var recipes:Array[Recipe]=[]:get=get_known_recipes
var player_unit:bool=true

func create(t:Territory,pu:bool,l:Person=null, c:Stockpile=null,o:Array[Stuff]=[],f:Population=null,coms=[]):
	creation_date=[GM.month,GM.week]
	player_unit=pu
	leader=l
	l.unit=self
	cargo=c
	outfit=o
	followers=f
	if coms:
		companions=coms
		for x in companions:
			x.unit=self
	companions.resize(4)
	original_territory=t
	current_territory=t
	if cargo==null:
		cargo=Stockpile.new()
	cargo.owner=self
	cargo.create(null,self)
	outfit.resize(4)
	guard.resize(4)
	if followers==null:
		followers=Population.new()
		followers.create(current_territory,self)
	if leader not in original_territory.NPCs:
		original_territory.NPCs.append(leader)
	for x in companions:
		if x:
			x.unit=self
	move(t)
	if leader:
		speed = leader.get_prowess(Person.PROWESS.LongStrider)+1
	if leader and !leader.recipes.is_empty():
		for x in leader.recipes:
			if x not in recipes:
				recipes.append(x)
	movements_allowed_this_turn=speed

func move(t:Territory):
	previous_territory=current_territory
	if current_territory and current_territory not in previous_territories:
		previous_territories.append(current_territory)
	current_territory.units.erase(self)
	if leader:
		leader.move(t)
	for x in companions:
		if x is Person:
			x.move(t)
	current_territory=t
	movements_allowed_this_turn-=1
	current_territory.units.append(self)
	followers.move(t)
	GM.board.update_board()
	GM.menus.update_menus()


func get_total_people():
	var p = 1 if leader else 0
	for x in companions:
		if x:
			p+=1
	return followers.get_total_population()+p

func get_total_followers():
	return followers.get_total_population()

	
func get_inventory_capacity():
	var r=1
	for x in outfit:
		if x.qualities.has(Stuff.QUALITIES.Capacity):
			r+=x.qualities[Stuff.QUALITIES.Capacity]
	r+=get_total_followers()
	cargo.storeroom_capacity=r
	cargo.granary_capacity=r
	

func remove_person(p:Person):
	if p==leader:
		leader.unit=null
		leader=null
	if p in companions:
		companions[companions.find(p)]=null
		p.unit=null
		
func add_cargo(s:Stuff,a:int):
	cargo.add_stuff(s,a)
	
func take_cargo(s:Stuff,a:int):
	cargo.remove_stuff(s,a)
	
	
func end_turn():
	turns_existed+=1
	for x in action_queue.duplicate():
		x.end_turn()
		if !x.is_alive():
			x.on_removal()
			action_queue.erase(x)
	leader.end_turn()
	for x in companions:
		if x:
			x.end_turn()
	followers.end_turn()
	for x in memories:
		x.end_turn()
	
	movements_allowed_this_turn=speed
	movements_allowed_this_turn-=action_queue.size()

func extract_buffs():
	var r:Array[Buffs] = []
	if leader:
		r.append(leader.personal_buffs)
	for x in companions:
		r.append(x.personal_buffs)
	return r

func get_prowess(p:Person.PROWESS):
	var prowess = leader.get_prowess(p) if leader else 0
	for x in companions:
		if x:
			prowess += x.get_prowess(p)
	for x in cargo.outfit:
		if x and x.conveys_prowess.has(p):
			prowess+=x.conveys_prowess[p]
	return prowess

func get_research():
	var x = []
	for y in companions:
		x.append(y)
	x.append(leader)
	for z in x:
		if !z.species.exp_to.is_empty():
			ResearchManager.get_exp_from_nymphoi(z)
			
func get_stat(s:Stats.STATS):
	var r = 0		
	var z = []
	var a = 0
	z.append(leader.get_stat(s))
	for x in companions:
		if x:
			z.append(x.stats.get_stat(s))
	for x in z:
		a+=x
	r = a/z.size()
	return r
	
func get_all_stats():
	var r = {}
	for x in Stats.STATS:
		r[x]=get_stat(x)
	return r

func add_event(e:Event,d:District=null,b:Building=null):
	if !e.check(d,current_territory,b):		
		return false
	e.init()
	if automate:
		e.turns=-1
	action_queue.append(e)
	movements_allowed_this_turn-=1
	return true

func remove_event(e:Event):
	e.on_removal(e.turns)
	action_queue.erase(e)

func disband():
	for x in followers.pops:
		followers.add_max(current_territory.population,x)
	for x in companions:
		if x:
			remove_person(x)
	
	if !leader:
		for x in cargo:
			current_territory.stockpile.add_max(x,cargo[x])
		current_territory.units.erase(self)
	
func foresake():
	pass		


	
	
func get_luck():
	var luck = get_stat(Stats.STATS.Luck)
	luck+=get_prowess(Person.PROWESS.Lucky)
	return luck

func _automate():
	for x in action_queue:
		x.turns=-1
	automate=true
	
func deautomate():
	for x in action_queue:
		x.turns=1
	automate=false

func get_known_recipes():
	var r:Array[Recipe] = []
	if leader:
		for x in leader.recipes:
			if x not in r:
				r.append(x)
	for x in companions:
		if x:
			for y in x.recipes:
				if y not in r:
					r.append(y)
	return r

func get_individuals():
	var r = []
	if leader!=null:
		r.append(leader)
	for x in companions:
		if x!=null:
			r.append(x)
	for x in guard:
		if x!=null:
			r.append(x)
	return r
	
func get_power():
	var r = 0
	for x:Person in get_individuals():
		r+=x.get_power()
	return r

func take_damage(a:float):
	for x:Person in get_individuals():
		
		x.stats.change_hp(a)

func dissappear():
	for x:Person in get_individuals():
		x.current_territory.NPCs.erase(x)
		x.leave_building()
	current_territory.units.erase(self)
