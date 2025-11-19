class_name Pop extends Resource

enum CLASS {Follower,Artist,Soldier,Monk,Underclass,Nymphoi}

@export var _class:CLASS
@export var persons:int
@export var beliefs:Beliefs
var owner
var territory:Territory
@export var unit:Unit
var illness
var hunger:int
var capacity:int

func create(c:CLASS,t:Territory=null,u:Unit=null):
	territory=u.current_territory if u else t
	_class=c
	unit=u
	beliefs=Beliefs.new()
	beliefs.create(_class)
	capacity=100
	if !unit:
		capacity=t.get_pop_cap(c)

func change_persons(a:int):
	capacity = territory.get_pop_cap(_class) if owner is Territory else 100
	if a+persons>capacity or a+persons<0:
		return false
	persons+=a
	GM.menus.update_pop_hud()
	return true

func move(t:Territory):
	territory=t
