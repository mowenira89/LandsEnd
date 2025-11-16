class_name Stats extends Resource

@export var total_hp:float
@export var offense:float
@export var defense:float
@export var speed:float
@export var current_hp:float

var owner

signal death

func create(o,hp:float,off:float,d:float,sp:float):
	owner=o
	total_hp=hp
	offense = off
	defense = d
	speed = sp
	current_hp=hp
	
	
func change_hp(a:float):
	current_hp=clamp(current_hp+a,0,total_hp)
	if current_hp==0:
		die()
		
func die():
	death.emit()
