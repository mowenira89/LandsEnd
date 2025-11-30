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
var NPCs_by_building:Dictionary[Building,Array]

var people_by_id:Dictionary[String,Person]

var cookhouse_recipes:Dictionary[String,CookhouseRecipe]
var khemic_recipes:Dictionary[String,KhemicRecipe]

func _ready():
	set_species()
	set_stuff()
	set_buildings()
	set_NPCs()
	set_recipes()
	

func check_exp_to():
	for x in RM.stuff.values():
		if !x.exp_to.is_empty():
			for y in x.exp_to.keys():
				if y not in ResearchManager.research.keys():
					print(x.name+" trying "+y)

func set_species():
	for x in Biome.TERRAIN.values():
		species_by_habitat[x]=[]
	var path = "res://Resources/Species/"
	var dir = ResourceLoader.list_directory(path)
	for x in dir:
		var new = load(path+x)
		if new is Species:
			species[new.name]=new
			new.init()
			for y in new.found_in:
				species_by_habitat[y].append(new)
			if new.kind==Species.KIND.Nymphoi:
				print(new.name)

	for x in stuff.values():
		if x is Crop:
			for t in x.found_in:
				species_by_habitat[t].append(x)

func set_buildings():
	var path = "res://Resources/Buildings/"
	var dir = ResourceLoader.list_directory(path)
	for x in dir:
		var new = load(path+x)
		buildings[new.name]=new
		if new.unlocked:
			GM.unlocked_buildings.append(new)
		if !new.image:
			print(new.name+" needs an image")
		
	for x in buildings:
		if buildings[x].upgrade_only:
			print(x +" is upgrade only")


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
		if new is Crop:
			species[new.name]=new
			for y in new.found_in:
				species_by_habitat[y].append(new)

	for x in stuff.values():
		if x.qualities.has(Stuff.QUALITIES.Libation):
			print(x.name + " Libation: " + str(x.qualities[Stuff.QUALITIES.Libation]))

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

func set_cookhouse_recipes():
	var path="res://Resources/CookhouseRecipes/"
	var dir = ResourceLoader.list_directory(path)
	for x in dir:
		var new = load(path+x)
		if new.id!="":
			crops[new.id]=new
		else:
			crops[x.name]=new




func get_stuff_of_quality(q:Stuff.QUALITIES):
	var r = []
	for x in stuff.values():
		if x.qualities.has(q):
			r.append(x)
	return r

func get_animals():
	var r = []
	for x in species.values():
		if x.kind not in [Species.KIND.Flora, Species.KIND.Nymphoi,Species.KIND.Germ]:
			r.append(x)
	return r
	
func get_plants():
	var r = []
	for x in species.values():
		if x.kind == Species.KIND.Flora:
			r.append(x)
	return r
	
	
func get_animals_by_mystic(m:Stuff.MYSTIC):
	var r = []
	for x in get_animals():
		if m in x.mystic_qualities.keys():
			r.append(x)
	return r

func get_plants_by_mystic(m:Stuff.MYSTIC):
	var r = []
	for x in get_plants():
		if m in x.mystic_qualities.keys():
			r.append(x)
	return r
