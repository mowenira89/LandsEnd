class_name Species extends Stuff 

enum DIET {Carnivore, Herbivore, Omnivore, Photosynthesis, Parasite, Insectivore}
enum KIND {Nymphoi,Mammal,Reptile,Bird,Amphibian,Arthropod,Flora,Germ,Fish,Insect}


@export var kind:KIND
@export var kill_produce:Dictionary[Stuff,int]
@export var harvest_produce:Dictionary[Stuff,int]
@export var rarity:float
@export var offense:float
@export var defense:float
@export var speed:float
@export var game:bool
@export var steed:bool
