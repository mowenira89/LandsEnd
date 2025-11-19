class_name Unit extends Resource

@export var name:String
@export var leader:Person
@export var cargo:Stockpile
@export var outfit:Stockpile
@export var followers:Population
@export var action_queue:Array[Event]=[]
@export var original_territory:Territory
@export var previous_territory:Territory
@export var current_territory:Territory
@export var destination_territory:Territory
@export var companions:Array[Person]=[]
@export var guards:Array=[]
@export var speed:int=1
@export var movements_allowed_this_turn=0
@export var traveling:bool=false
@export var friendly:bool=true
@export var memories:Array[Memory]
@export var prohibited_game:Array[Species]
#STATS
@export var animals_killed:int=0
@export var previous_territories:Array[Territory]
@export var turns_existed:int=0
@export var creation_date=[]


@export var outfit_order:Array[Stuff]

func create(t:Territory,l:Person=null, c:Stockpile=null,o:Stockpile=null,f:Population=null,coms=[]):
	creation_date=[GM.month,GM.week]
	leader=l
	l.unit=self
	cargo=c
	outfit=o
	followers=f
	if coms:
		companions=coms
		for x in companions:
			x.unit=self
	outfit_order.resize(4)
	companions.resize(4)
	original_territory=t
	current_territory=t
	if cargo==null:
		cargo=Stockpile.new()
	cargo.owner=self
	cargo.create(null,self)
	if outfit==null:
		outfit=Stockpile.new()
		outfit.create(null,self)
	if followers==null:
		followers=Population.new()
		followers.create(current_territory,self)
	if leader not in original_territory.NPCs:
		original_territory.NPCs.append(leader)
	for x in companions:
		if x:
			x.unit=self
	move(t)
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


func get_total_followers():
	return followers.get_total_population()
	

	
func change_inventory_capacity():
	var r=1
	for x in outfit.keys():
		if x.qualities.has(Stuff.QUALITIES.Capacity):
			r+=x.qualities[Stuff.QUALITIES.Capacity]*outfit[x]
	r+=get_total_followers()
	cargo.capacity=r
	

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
			action_queue.erase(x)
	leader.end_turn()
	for x in companions:
		if x:
			x.end_turn()
	
	for x in memories:
		x.end_turn()
	
	movements_allowed_this_turn=speed

func get_all_buffs(t:Buff.TYPE):
	var amt=0
	if leader:
		amt+=get_all_buffs(t)
	for x in companions:
		amt+=get_all_buffs(t)
	
	return amt

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
	z.append(leader.stats.get_stat(s))
	for x in companions:
		if x:
			z.append(x.stats.get_stat(s))
	for x in z:
		a+=x
	r = a*z.size()
	return r

func add_event(e:Event,d:District=null,b:Building=null):
	if !e.check(d,d.territory,b):		
		return false
	e.init()
	action_queue.append(e)
	return true

func remove_event(e:Event):
	e.on_removal(e.turns)
	action_queue.erase(e)

func disband():
	for x in followers.pops:
		followers.add_max(current_territory.population,x)
	for x in companions:
		if x:
			leave_party(x)
	
	if !leader:
		for x in cargo:
			current_territory.stockpile.add_max(x,cargo[x])
		current_territory.units.erase(self)
	
func foresake():
	pass		

func leave_party(p:Person):
	var u = Unit.new()
	u.create(current_territory,p)
	
