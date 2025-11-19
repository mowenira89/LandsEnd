class_name TempleMenu extends Control

var building:Temple
@onready var dedication: PersonSelectorButton = $MarginContainer/ColorRect/MarginContainer/VBoxContainer/HBoxContainer/PersonSelectorButton

@onready var incense: SelectorButton = $MarginContainer/ColorRect/MarginContainer/VBoxContainer/HBoxContainer/BonusHolder/SelectorButton
@onready var music: SelectorButton = $MarginContainer/ColorRect/MarginContainer/VBoxContainer/HBoxContainer/BonusHolder/SelectorButton2



func update_menu(b:Building):
	building=b
	dedication.create(building.dedication)
	
	
func _update_menu():
	update_menu(building)


func open_selection_window(b:SelectorButton):
	pass
	
func on_remove(b:SelectorButton):
	if b == music:
		building.music=null
	elif b == incense:
		building.incense=null
	b.reset()

func open_incense():
	var i = building.district.territory.stockpile.get_of_quality(Stuff.QUALITIES.Incense)
	GM.menus.stuff_selector_screen.update_menu(i.keys())
	GM.menus.stuff_selector_screen.send_stuff.connect(receive_incense)
	
func receive_incense(s:String):
	incense.create(RM.stuff[s])
	GM.menus.stuff_selector_screen.send_stuff.disconnect(receive_incense)
	
func open_music():
	var i = building.district.territory.stockpile.get_of_quality(Stuff.QUALITIES.Instrument)
	GM.menus.stuff_selector_screen.update_menu(i.keys())
	GM.menus.stuff_selector_screen.send_stuff.connect(receive_music)
	
func receive_music(s:String):
	music.create(RM.stuff[s])
	GM.menus.stuff_selector_screen.send_stuff.disconnect(receive_incense)
	
