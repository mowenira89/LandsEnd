class_name Temple extends Building

var storeroom:Stockpile
var dedication:Nymphoi
var sanctity:float
var defilment:float
var ceremonies:Array[Event]
@export var pilgrim_draw:float

func create(d:District):
	super(d)
	storeroom.owner=d.territory

func do_ceremony():
	pass

func level_up():
	super()
	
func upgrade(b:Building):
	super(b)
	pilgrim_draw+=upgrading_to.pilgrim_draw
