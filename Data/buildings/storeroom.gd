class_name Storeroom extends Building

@export var granary_cap:int
@export var storeroom_cap:int
@export var animal_fields:int


func create(d:District):
	super(d)
	district.territory.stockpile.granary_capacity+=granary_cap
	district.territory.stockpile.storeroom_capacity+=storeroom_cap
	district.territory.stockpile.animal_fields+=animal_fields
	

func destroy_building(burn:bool=false):
	district.territory.stockpile.granary_capacity-=granary_cap
	district.territory.stockpile.storeroom_capacity-=storeroom_cap
	district.territory.stockpile.animal_fields-=animal_fields
	super(burn)	
