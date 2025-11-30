class_name DeliverStuffEvent extends Event

@export var district:District
@export var amt:float
@export var stockpile:Stockpile

func make_plans(d:District,s:Stockpile,a:float):
	district=d
	stockpile=s
	amt=a
	message="Digging in "+d.name
	
func apply():
	var stuff = district.biome.mineable
	if stuff:
		stockpile.add_max(stuff,amt)
	
