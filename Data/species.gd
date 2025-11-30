class_name Species extends Stuff 

enum DIET {Omnivore, Carnivore, Herbivore, Photosynthesis, Parasite, Insectivore}
enum KIND {Nymphoi,Mammal,Reptile,Bird,Amphibian,Arthropod,Flora,Germ,Fish,Insect}


@export var kind:KIND
@export var diet:DIET
@export var natural_prowess:Dictionary[Person.PROWESS,int]
@export var kill_produce:Dictionary[Stuff,int]
@export var harvest_produce:Dictionary[Stuff,int]
@export var harvest_season:Array[GM.MONTHS]
@export var breeding_season:Array[GM.MONTHS]
@export var fertility:float=.5
@export var rarity:float
@export var domestication_difficulty:float=0
@export var game:bool
@export var steed:bool
@export var aggressiveness:float
@export var skittishness:float
@export var produce_manure:bool
@export var food_need:float=.1
@export var knowledge:Array[Research]

func init():
	stats.init(self)
