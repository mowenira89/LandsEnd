class_name Farm extends Building

var fields:int=0:get=get_fields
var crops:Array[Crop]=[]
var livestock:Array[Herd]
var fertilizer:Stuff
var fertilizer_buffer:float

var preserving:Dictionary[int,Dictionary]


@export var raise_crops:bool
@export var raise_livestock:bool

func create(d:District):
	super(d)
	crops.resize(9)
	livestock.resize(9)
	utilized_districts.append(district)
	district.type=District.TYPES.Agricultural
	
func get_fields():
	return (utilized_districts.size()*3)
	
func end_turn():
	super()
	for x in livestock:
		if x is Herd:
			x.handle(district,boss)
	for x in crops:
		if x:
			x.grow(district,boss)
	for x in preserving:
		if producing_this_turn[x]=="Make Preserves":
			make_preserves(x)



			

func get_production_options():
	var a:Array[String]=[]
	a.append("Craft")
	if raise_crops:
		a+=["Plant Crops","Chop Wood","Make Preserves"] 
	return a

func save():
	var s = get_save()
	s['crops']={}
	for x in crops.size()-1:
		if crops[x]:
			s['crops'][x]=crops[x].save()
	
func set_production(s:String,i:int,r:Recipe=null):
	super(s,i,r)
	if s=="Make Preserves":
		GM.menus.preserve_menu.update_menu(self,i)

func make_preserves(i:int):
	var p = preserving[i]
	for x in p:
		if !p[x]:
			return
		if district.territory.stockpile.check_stuff_amount(p[x])<1:
			return
	for x in p:
		district.territory.stockpile.remove_stuff(p[x],1)
	var stuff:Stuff
	if p[PreserveMenu.COMPONENTS.Preservative]==RM.stuff["Vinegar"]:
		stuff=RM.stuff["Pickles"]
	else:
		stuff=RM.stuff["Jam"]
	district.territory.stockpile.add_stuff(stuff,1)

func set_crop(c:Crop,i:int):
	crops[i]=c.duplicate()
	crops[i].create()
	
func set_livestock(s:Species,i:int):
	var amt = district.territory.stockpile.check_stuff_amount(s)
	district.territory.stockpile.remove_stuff(s,amt)
	var h = Herd.new()
	h.create(s,amt)
	livestock[i]=h
	
func get_menu():
	GM.menus.farm_view.update_menu(self)
