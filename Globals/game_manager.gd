extends Node

enum MONTHS {VERDUS, SPRINGSHINE, HIGHSUN, EQUINOXIA, HARVEST, FALLOWFELL, DREAMTIME, FIMBUL, THAWBRAWN}

var board:Board
var menus:MenuController
var camera:Camera
var battle_state_machine:BattleStateMachine

var end_turn_messages:Array[String]=[]
var unique_spawns:Array[Person]=[]
var event_queue:Array[Event]

var owned_territories:Array[Territory]
var unlocked_buildings:Array[Building]
var unlocked_crops:Array[Crop]
#STATS
var turns=1
var animals_killed:int=0

var leader:Person

var month:MONTHS=1 as MONTHS
var week:int=1
var year:int=1
var winter = [MONTHS.DREAMTIME,MONTHS.FIMBUL,MONTHS.THAWBRAWN]
#COLORS
const GREEN = "#378b41"
const RED = "#f16568"

var demo=true

signal select_territory
signal end_turn_message

var afterlife:Dictionary[Person,int]={}

var starting_territory:Territory

const EVENT_BUTTON = preload("res://Menus/event_button.tscn")

func _ready():
	pass

func start_new_game():
	starting_territory = GM.board.tiles_by_cell.values().pick_random().data
	GM.create_initial_party(starting_territory)
	GM.board.center_camera(starting_territory.coords)
	GM.board.update_board()
	
	if demo:
		owned_territories.append(starting_territory)
		starting_territory.districts[0].building=RM.buildings["Camp"].duplicate()
		starting_territory.districts[0].building.create(starting_territory.districts[0])
		starting_territory.districts[1].building=RM.buildings["Farm"].duplicate()
		starting_territory.districts[1].building.create(starting_territory.districts[1])
		starting_territory.districts[2].building=RM.buildings["Market"].duplicate()
		starting_territory.districts[2].building.create(starting_territory.districts[2])
		var starting_stockpile = {
			RM.stuff['Honey']:10,
			RM.stuff['Onion']:10,
			RM.stuff["Sandalwood Oil"]:10,
			RM.stuff['Coal']:10
		}
		for x in starting_stockpile:
			starting_territory.stockpile.add_stuff(x,starting_stockpile[x])
		for x in RM.buildings.values():
			GM.unlocked_buildings.append(x)
		for x in RM.stuff.values():
			if x is Crop:
				unlocked_crops.append(x)
		make_initial_foe(starting_territory)
				
				
				


func add_event(e:Event,d:District=null,b:Building=null,u:Unit=null):
	if !e.check(d,d.territory,b,u):		
		return false
	e.init()
	event_queue.append(e)
	return true

func remove_event(id:String):
	for x in event_queue:
		if x.id==id:
			for y in x.effects:
				y.on_removal(x.turns)
			event_queue.erase(x)
			break

func end_turn():
	
	GM.menus.end_turn_box.turn_label.text=MONTHS.keys()[month]+" Week "+str(week)
	
	turns+=1
	week+=1
	if week>=4:
		week=1
		month+=1
		if month==MONTHS.size():
			month=0
			year+=1


	for x in GM.board.tiles_by_cell.values():
		x.data.end_turn()

	for x in event_queue.duplicate():
		x.end_turn()
		if !x.is_alive():
			event_queue.erase(x)
	
	GM.menus.update_menus()
	GM.menus.end_turn_box.display_messages()

func initial_setup():
	var c = load("res://Resources/Ceremonies/dance.tres")

func create_initial_party(t:Territory):
	var scout = RM.NPCs["Hunter"].duplicate()
	scout.create(t,RM.species["Human"],1,20)
	var unit = Unit.new()
	var stockpile = Stockpile.new()
	stockpile.create(null,unit)
	var population = Population.new()
	population.create(starting_territory,unit)
	population.change_pop(Pop.CLASS.Follower,10)
	unit.create(t,true,scout,stockpile,[],population)
	var initial_stuff = {
		RM.stuff["Wood"]:10,
		RM.stuff["Canvas"]:10,
		RM.stuff["Bread"]:4,
		RM.stuff["Cart"]:1
	}
	for x in initial_stuff:
		unit.add_cargo(x,initial_stuff[x])




func get_prowess(p:Person.PROWESS,b:Building=null,u:Unit=null):
	var prowess:float=0
	var t:Territory
	if b:
		t=b.district.territory
	elif u:
		t=u.current_territory
	for x in t.NPCs:
		if x.territorial_prowess.has(p):
			if x.friend:
				prowess+=x.territorial_prowess[p]
			else:
				prowess-=x.territorial_prowess[p]
	if b:
		if b.boss.prowess.has(p):
			if b.boss.friend:
				prowess+=b.boss.prowess[p]
			else:
				prowess-=b.boss.prowess[p]
	elif u:
		prowess+=u.get_powess(p)
	return prowess

func make_initial_foe(t:Territory):
	var unit:Unit = Unit.new()
	var monster:Person = Person.new()
	monster.create(t,RM.species["Kobold"],-1,1)
	unit.create(t,false,monster)
