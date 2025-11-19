class_name ExchangeWindow extends Control

@onready var stuff_movers: VBoxContainer = $ColorRect/MarginContainer/HBoxContainer/VBoxContainer/ScrollContainer/StuffMovers
@onready var people_movers: VBoxContainer = $ColorRect/MarginContainer/HBoxContainer/VBoxContainer2/ScrollContainer/PeopleMovers


const STUFF_MOVER = preload("res://Menus/stuff_mover.tscn")
const PEOPLE_MOVER = preload("res://Menus/people_mover.tscn")

var stuffa:Stockpile
var stuffb:Stockpile
var popa:Population
var popb:Population

func _update_menu():
	update_menu(stuffa,stuffb,popa,popb)

func update_menu(stuff_a,stuff_b,pop_a,pop_b):
	stuffa=stuff_a
	stuffb=stuff_b
	popa=pop_a
	popb=pop_b
	
	for x in stuff_movers.get_children():
		x.queue_free()
	for x in people_movers.get_children():
		x.queue_free()
	var stuff_in=[]
	for x in stuffa.stuff.keys():
		if x not in stuff_in:
			var new_mover=STUFF_MOVER.instantiate()
			stuff_movers.add_child(new_mover)
			new_mover.create(x,stuffa,stuffb)
		stuff_in.append(x)
	for x in stuffb.stuff.keys():
		if x not in stuff_in:
			var new_mover=STUFF_MOVER.instantiate()
			stuff_movers.add_child(new_mover)
			new_mover.create(x,stuffa,stuffb)
	for x in popa.pops:
		var new_mover=PEOPLE_MOVER.instantiate()
		people_movers.add_child(new_mover)
		new_mover.create(x,popa,popb)
	GM.menus.switch_side_bottom(self)


func _on_button_pressed() -> void:
	visible=false
