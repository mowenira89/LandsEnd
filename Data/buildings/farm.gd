class_name Farm extends Building

@export var fields:int=3
@export var crops:Array[Crop]=[]
@export var livestock:Array[Species]
var growth=[]

func create(d:District):
	super(d)
	crops.resize(9)
	growth.resize(9)
	
func end_turn():
	for x in crops:
		x.starting_up-=1
	for x in crops:
		if x is Crop:
			if GM.month in x.dead_season:
				growth[x]=0
			if GM.month not in x.dead_season:
				if x.starting_up<=0:
					grow()
			if GM.month in x.harvest_season:
				for y in x.produce:
					district.stockpile.add_stuff(y,growth[x])
				

func plant_crop(c:Crop,i:int):
	crops[i]=c.duplicate()
	crops[i].starting_up=crops[i].startup_time

func grow():	
	if district.biome.water<0:
		return false
	
	for x in fields:
		if crops[x]:
			var growth_this_turn=0
			for y in crops[x].vitamins_needed:
				district.biome.vitamins[y]-=crops[y].vitamin_need
				if !district.biome.vitamins[y]<0:
					growth_this_turn+=.2
			var green_thumb = GM.get_prowess(Person.PROWESS.GreenThumb,self)
			growth_this_turn+=growth_this_turn*green_thumb/10
			growth[x]+=growth_this_turn
			
func get_extention(b:Building):
	if b is Pasture:
		fields+=b.fields
		district.territory.stockpile.animal_fields+=b.field_capacity
