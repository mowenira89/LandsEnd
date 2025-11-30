class_name Camp extends Building

@export var fish:bool
@export var hunt:bool
@export var forage:bool
@export var chop_wood:bool

@export var prohibited_game:Array[Species]=[]

func get_production_options():
	var r:Array[String] = ["Craft"]
	if hunt:
		r.append("Hunt")
	if forage:
		r.append("Forage")
	if fish:
		r.append("Fish")
	if chop_wood:
		r.append("Chop Wood")
	r.append("Obtain")
	return r
	
func get_menu():
	GM.menus.basic_building_view.update_menu(self)

func progress_production():
	super()
	for x in producing_this_turn.size()-1:
		if producing_this_turn[x] is String:
			match producing_this_turn[x]:
				"Hunt":
					var hunt_event = HuntEvent.new()
					hunt_event.make_plans(district.territory.population,self)
					GM.add_event(hunt_event,district,self)
				"Fish":
					var f = FishingEvent.new()
					f.make_plans(district.territory.population,district,null)
					GM.add_event(f,district,self)
				"Chop Wood":
					var c = ChopWoodEvent.new()
					c.make_plans(district.territory.population,district)
					GM.add_event(c,district,self)
				"Forage":
					var f = ForageEvent.new()
					f.make_plans(district.territory.population,self)
					GM.add_event(f,district,self)
				
		elif producing_this_turn[x] is ObtainEvent:
			producing_this_turn[x].apply()
