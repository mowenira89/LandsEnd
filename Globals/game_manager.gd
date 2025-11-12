extends Node

enum MONTHS {Verdus, Springshine, Highsun, Equinoxia, Harvest, Fallowfell, Dreamtime, Fimbul, Thawbrawn}

var board:Board
var menus:MenuController
var camera:Camera

var end_turn_messages:Array[String]=[]

var event_queue:Array[Event]
var finished_events:Array[Event]

var owned_territories:Array[Territory]
var unlocked_buildings:Array[Building]

#STATS
var turns=1

var month:MONTHS=1 as MONTHS
var week:int=1
#COLORS
const GREEN = "#378b41"
const RED = "#f16568"

func _ready():
	start_new_game()

func start_new_game():
	pass

func add_event(e:Event):
	for x in e.effects:
		x.init()
	event_queue.append(e)

func remove_event(id:String):
	for x in event_queue:
		if x.id==id:
			for y in x.effects:
				y.on_removal()
			event_queue.erase(x)
			break

func end_turn():

	turns+=1
	week+=1
	if week>=4:
		week=1
		month+=1
		if month==MONTHS.size():
			month=1

	for x in event_queue:
		x.end_turn()
	for x in finished_events:
		event_queue.erase(x)
	finished_events.clear()
