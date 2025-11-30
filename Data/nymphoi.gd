class_name Nymphoi extends Person

@export var credit:float
@export var favorite_incense:Stuff
@export var favorite_animal:Species
@export var favorite_plant:Species
@export var favorite_music:Stuff
@export var favorite_art:Studio.TYPE
@export var favorite_food:Stuff
@export var base_power:float
var favor:int=0
var insult:int=0



var favorites = [favorite_incense,favorite_animal,favorite_plant,favorite_music,favorite_art,favorite_food]

enum BLURSES {Fertile,Blessed,Cursed,Haunted}

func create(t:Territory,k:Species,friendliness:float,age:int):
	super(t,k,friendliness,age)
	var m = species.mystic_qualities.keys()
	affinity=m
	favorite_incense = RM.get_stuff_of_quality(Stuff.QUALITIES.Incense).pick_random()
	favorite_animal = RM.get_animals_by_mystic(m.pick_random()).pick_random()
	favorite_music = RM.get_stuff_of_quality(Stuff.QUALITIES.Instrument).pick_random()
	favorite_art = Studio.TYPE.keys().pick_random()
	favorite_food = RM.get_stuff_of_quality(Stuff.QUALITIES.Food).pick_random()
	favorite_plant = RM.get_plants_by_mystic(m.pick_random()).pick_random()
	
	
func accept_offering(s:Stuff,a:int):
	var affinity_factor=1
	for x in affinity:
		if x in s.mystic_qualities:
			affinity_factor+=s.mystic_qualities[x]/10
			
	var c = s.qualities[Stuff.QUALITIES.Sacred]*5*a
	get_credit(c*affinity_factor)	
	
func get_credit(a:float):
	if Stuff.MYSTIC.Eldrich in affinity:
		credit+=a
		return true
	credit+=a/2
	var amt=(a/2)/affinity.size()
	for x in affinity:
		MagicManager.credit[x]+=amt
