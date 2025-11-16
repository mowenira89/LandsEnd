class_name Pop extends Resource

enum CLASS {Follower,Artist,Soldier,Monk,Underclass,Nymphoi}

@export var _class:CLASS
@export var persons:int
@export var beliefs:Beliefs
@export var territory:Territory
@export var unit:Unit
var illness
var hunger:int
var capacity:int

func create(c:CLASS,t:Territory=null,u:Unit=null):
	territory=t
	_class=c
	unit=u
	beliefs=Beliefs.new()
	beliefs.create(_class)
	capacity=10
	if territory:
		capacity+=t.get_pop_cap(c)

func change_persons(a:int):
	if a+persons>capacity or a+persons<0:
		return false
	persons+=a
	GM.menus.update_pop_hud()
	return true
