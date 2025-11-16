class_name Temple extends Building

var storeroom:Stockpile
var dedication:Nymphoi
var sanctity:float
var defilment:float
var ceremonies:Array[Event]

func create(d:District):
	super(d)
	storeroom.owner=d.territory

func do_ceremony():
	pass
