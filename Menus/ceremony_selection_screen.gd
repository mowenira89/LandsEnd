class_name CeremonySelectionScreen extends Control

@onready var vbox: VBoxContainer = $MarginContainer/ScrollContainer/VBoxContainer

var building:Temple
var unit:Unit

func update_menu(b:Temple,u:Unit):
	building=b
	unit=u
	
	for x in vbox.get_children():
		x.queue_free()

	if building:
		if !building.dedication and !building.dedicated_lesser:
			var button=Button.new()
			vbox.add_child(button)
			button.text="Dedication Ceremony"
			button.pressed.connect(func(y=button.text):GM.menus.send_data.emit.call(y))
		else:
			all_unlocked()
	else:
		all_unlocked()
	GM.menus.switch_side_bottom(self)

func all_unlocked():
	for x in MagicManager.unlocked_ceremonies:
		var button = Button.new()
		vbox.add_child(button)
		button.text=x.name
		button.pressed.connect(func(y=x):GM.menus.send_data.emit.call(y))
		
	GM.menus.switch_side_bottom(self)

func _update_menu():
	update_menu(building,unit)
