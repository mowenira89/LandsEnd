class_name Nymphoi extends Person

@export var credit:float
@export var affinity:Array[Stuff.MYSTIC]
@export var favorite_incense:Stuff
@export var favorite_animal:Species
@export var favorite_plant:Species
@export var favorite_music:Stuff
@export var favorite_art:Studio.TYPE
@export var favorite_food:Stuff

func create(t:Territory,k:Species):
	var m = species.mystic_qualities.keys()
	affinity=m
	favorite_incense = RM.get_stuff_of_quality(Stuff.QUALITIES.Incense).pick_random()
	favorite_animal = RM.get_animals_by_mystic(m[0]).pick_random()
	favorite_music = RM.get_stuff_of_quality(Stuff.QUALITIES.Instrument).pick_random()
	favorite_art = Studio.TYPE.keys().pick_random()
	favorite_food = RM.get_stuff_of_quality(Stuff.QUALITIES.Food).pick_random()
	favorite_plant = RM.get_plants_by_mystic(m[0]).pick_random()
	
	
