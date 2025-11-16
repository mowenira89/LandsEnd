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
		r.append("Gather")
	if fish:
		r.append("Fish")
	if chop_wood:
		r.append("Chop Wood")
	return r
	
func get_menu():
	GM.menus.basic_building_view.update_menu(self)

func progress_production():
	super()
	for x in producing_this_turn.size()-1:
		if producing_this_turn[x] is String:
			match producing_this_turn[x]:
				"Hunt":
					var hunt_effect=HuntEffect.new()
					hunt_effect.create(district.territory.stockpile,null,self)
					var id = district.territory.name+str(district.index)+str(x)+"production_event"
					var new_event=Event.new()
					var m = "Hunting"
					new_event.create(id,m)
					new_event.effects.append(hunt_effect)
					GM.add_event(new_event)
				"Fish":
					pass
				"Chop Wood":
					pass
				"Gather":
					pass
