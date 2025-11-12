extends Node

var species:Dictionary[String,Species] = {}
var species_by_habitat:Dictionary[Biome.TERRAIN,Array]
var stuff:Dictionary[String,Stuff]
var mineables_by_terrain:Dictionary[Biome.TERRAIN,Array]
var forage_by_terrain:Dictionary[Biome.TERRAIN,Array]
var buildings:Dictionary[String,Building]

func _ready():
	set_species()
	set_stuff()
	set_buildings()

func set_species():
	for x in Biome.TERRAIN.values():
		species_by_habitat[x]=[]
	var path = "res://Resources/Species/"
	var dir = ResourceLoader.list_directory(path)
	for x in dir:
		var new = load(path+x)
		if new is Species:
			species[new.name]=new
			for y in new.found_in:
				species_by_habitat[y].append(new)

func set_buildings():
	var path = "res://Resources/Buildings/"
	var dir = ResourceLoader.list_directory(path)
	for x in dir:
		var new = load(path+x)
		buildings[new.name]=new
		if new.unlocked:
			GM.unlocked_buildings.append(new)


func set_stuff():
	for x in Biome.TERRAIN.values():
		mineables_by_terrain[x]=[]
		forage_by_terrain[x]=[]
	var path="res://Resources/Stuff/"
	var dir = ResourceLoader.list_directory(path)
	for x in dir:
		var new = load(path+x)
		if new is Stuff:
			stuff[new.name]=new
			if new.qualities.has(Stuff.QUALITIES.Mineable):
				for y in new.found_in:
					mineables_by_terrain[y].append(new)
			if new.qualities.has(Stuff.QUALITIES.Forage):
				for y in new.found_in:
					forage_by_terrain[y].append(new)
