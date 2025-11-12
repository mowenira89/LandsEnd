class_name Pop extends Resource

enum CLASS {Follower,Artist,Soldier,Monk,Underclass,Nymphoi}

@export var _class:CLASS
@export var persons:int
@export var beliefs:Beliefs
@export var territory:Territory
var illness
var hunger:int

func create(c:CLASS,t:Territory):
	territory=t
	_class=c
	beliefs=Beliefs.new()
	beliefs.create(_class)
