extends Node

enum MONTHS {VERDUS, SPRINGSHINE, HIGHSUN, EQUINOXIA, HARVEST, FALLOWFELL, DREAMTIME, FIMBUL, THAWBRAWN}

var board:Board
var menus:MenuController
var camera:Camera

var end_turn_messages:Array[String]=[]

var event_queue:Array[Event]

var owned_territories:Array[Territory]
var unlocked_buildings:Array[Building]

#STATS
var turns=1
var animals_killed:int=0

var leader:Person

var month:MONTHS=1 as MONTHS
var week:int=1
#COLORS
const GREEN = "#378b41"
const RED = "#f16568"

var demo=true

signal select_territory
signal end_turn_message

const EVENT_BUTTON = preload("res://Menus/event_button.tscn")

func _ready():
	pass

func start_new_game():
	var starting_territory = GM.board.tiles_by_cell.values().pick_random().data
	GM.create_initial_party(starting_territory)
	GM.board.center_camera(starting_territory.coords)
	GM.board.update_board()
	
	if demo:
		owned_territories.append(starting_territory)
		starting_territory.districts[0].building=RM.buildings["Camp"].duplicate()
		starting_territory.districts[0].building.create(starting_territory.districts[0])


func add_event(e:Event):
	
	for x in e.effects:
		if !x.check():		
			return false
	for x in e.effects:
		x.init()
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
			month=1

	for x in event_queue.duplicate():
		x.end_turn()
		if !x.is_alive():
			event_queue.erase(x)
			
	for x in board.tiles_by_cell.values():
		x.data.end_turn()
			
	GM.menus.update_menus()

func create_initial_party(t:Territory):
	var scout = RM.NPCs["Scout"].duplicate()
	scout.create(t)
	var unit = Unit.new()
	var stockpile = Stockpile.new()
	var outfit = Stockpile.new()
	var population = Population.new()
	population.create(null,unit)
	outfit.add_stuff(RM.stuff["Cart"],1)
	var initial_stuff = {
		RM.stuff["Wood"]:10,
		RM.stuff["Canvas"]:10,
		RM.stuff["Bread"]:4
	}
	for x in initial_stuff:
		stockpile.add_stuff(x,initial_stuff[x])
	unit.create(t,scout,stockpile,outfit,population)



func get_buffs(t:Buff.TYPE,b:Building=null,ter:Territory=null,u:Unit=null):
	var r = 0
	if b:
		r += b.buffs.get_buffs_total(t)
	if ter:
		r += ter.buffs.get_buffs_total(t)
	if u:
		r += u.get_all_buffs(t)
	return r
