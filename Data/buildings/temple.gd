class_name Temple extends Building

var storeroom:Stockpile
var dedication:Nymphoi
var spirit_dedication:Stuff.MYSTIC
var dedicated_lesser:bool=false
var dedication_ceremony:bool=false
var sanctity:float
var defilment:float
var ceremonies:Array[Ceremony]
@export var pilgrim_draw:float
@export var reliquary_size:int=1
var offerings:Array[Stuff]=[]
var offering_amts:Array[int]=[]
var incense:Stuff
var incense_buffer:float
var music:Stuff
var fuel:Stuff
var fuel_buffer:float

var ceremonies_performed = {}

func create(d:District):
	super(d)
	storeroom=Stockpile.new()
	storeroom.create(null,null,self)
	ceremonies.resize(2)
	

func conduct_ceremony():
	pass

func level_up():
	super()
	
func upgrade(b:Building):
	super(b)
	pilgrim_draw+=upgrading_to.pilgrim_draw

func get_production_options():
	var r:Array[String]=["Craft","Chant","Make Offering"]
	return r
	
func end_turn():
	super()
	tend_temple()
	for x in 2:
		if ceremonies[x] is Ceremony:
			ceremonies[x].end_turn()
			if !ceremonies[x].is_alive():
				ceremonies[x]=null
	


func tend_temple():
	incense_buffer-=level/5
	if incense_buffer<=0:
		if storeroom.remove_stuff(incense,1):
			incense_buffer+=incense.get_quality(Stuff.QUALITIES.Incense)
		if district.territory.stockpile.remove_stuff(incense,1):
			incense_buffer+=incense.get_quality(Stuff.QUALITIES.Incense)
	fuel_buffer-=level/10
	if fuel_buffer<=0:	
		if storeroom.remove_stuff(fuel,1):
			fuel_buffer+=fuel.get_quality(Stuff.QUALITIES.Fuel)
		elif district.territory.stockpile.remove_stuff(fuel,1):
			fuel_buffer+=fuel.get_quality(Stuff.QUALITIES.Fuel)


func set_dedication(p:Nymphoi):
	dedication=p
	dedicated_lesser=false
	
func lesser_dedication(s:Stuff.MYSTIC):
	spirit_dedication=s
	dedicated_lesser=true

func set_production(s:String,i:int,r:Recipe=null):
	super(s,i,r)
	if s=="Chant":
		pass
	if s=="Make Offering":
		GM.menus.item_amount_selector.update_menu(district.territory.stockpile)
		var choice = await GM.menus.item_amount_selector.get_stuff_and_amount
		if choice:
			offerings[i]=choice
		GM.menus.switch_side_bottom(GM.menus.previous_side_bottom)
		GM.menus.update_menus()
		
		
func get_menu():
	GM.menus.temple_menu.update_menu(self)

func progress_production():
	super()
	for x in offerings.size()-1:
		if offerings[x]:
			make_offering(offerings[x],offering_amts[x])
			offerings[x]=null
			
func make_offering(s:Stuff,a:int):
	var value = s.value
	value+=s.get_quality(Stuff.QUALITIES.Sacred)*a
	if incense_buffer>0:
		value+=value*(incense.get_quality(Stuff.QUALITIES.Incense)/100)
	if district.territory.stockpile.remove_stuff(s,1):
		if dedication:
			dedication.accept_offering(s,a)
		elif dedicated_lesser:
			MagicManager.credit[spirit_dedication]+=value/32
