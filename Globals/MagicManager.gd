extends Node

var credit = {
	Stuff.MYSTIC.Sylvan:0,
	Stuff.MYSTIC.Cthonic:0,
	Stuff.MYSTIC.Water:0,
	Stuff.MYSTIC.Fire:0,
	Stuff.MYSTIC.Air:0,
	Stuff.MYSTIC.Divine:0,
	Stuff.MYSTIC.Eldrich:0,
}

var ceremonies_performed = {}
var unlocked_ceremonies:Array[Ceremony]
var ceremonies:Dictionary[String,Ceremony] = {}

var lesser_spirits = {
	Stuff.MYSTIC.Sylvan:"Spirits of the Forest",
	Stuff.MYSTIC.Cthonic:"Cthonic Spirits",
	Stuff.MYSTIC.Fire:"Spirits of Flame",
	Stuff.MYSTIC.Water:"Spirits of the Fountain",
	Stuff.MYSTIC.Air:"Spirits of the Air",
	Stuff.MYSTIC.Divine:"Spirits of the Quintessence",
	Stuff.MYSTIC.Eldrich:"Spirits of the Unknown"
}

func _ready():
	set_ceremonies()
	set_lesser_spirits()

func set_ceremonies():
	var path = "res://Resources/Ceremonies/"
	var dir = ResourceLoader.list_directory(path)
	for x in dir:
		var new = load(path+x)
		if new is Ceremony:
			ceremonies[new.name]=new
			if new.unlocked:
				unlocked_ceremonies.append(new)

func set_lesser_spirits():
	var path = "res://Resources/lesser_spirits/"
	var dir = ResourceLoader.list_directory(path)
	for x in dir:
		var new = load(path+x)
		if new is Nymphoi:
			lesser_spirits[new.affinity[0]]=new
