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
	if outfit==null:
		outfit=Stockpile.new()
		outfit.owner=self
	if followers==null:
		followers=Population.new()
		followers.create(null,self)
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
