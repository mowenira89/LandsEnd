extends Node

var species:Dictionary[String,Species] = {}
var species_by_habitat:Dictionary[Biome.TERRAIN,Array]
var stuff:Dictionary[String,Stuff]
var mineables_by_terrain:Dictionary[Biome.TERRAIN,Array]
var forage_by_terrain:Dictionary[Biome.TERRAIN,Array]
var buildings:Dictionary[String,Building]
var NPCs:Dictionary[String,Person]
var recipes:Dictionary[String,Recipe]
var crops:Dictionary[String,Crop]

func _ready():
	set_species()
	set_stuff()
	set_buildings()
	set_NPCs()

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

func set_NPCs():
	var path="res://Resources/NPCs/"
	var dir = ResourceLoader.list_directory(path)
	for x in dir:
		var new = load(path+x)
		NPCs[new.title]=new

func set_recipes():
	var path="res://Resources/recipes/"
	var dir = ResourceLoader.list_directory(path)
	for x in dir:
		var new = load(path+x)
		recipes[new.id]=new

func set_crops():
	var path="res://Resources/Crops/"
	var dir = ResourceLoader.list_directory(path)
	for x in dir:
		var new = load(path+x)
		if new.id!="":
			crops[new.id]=new
		else:
			crops[x.name]=new
