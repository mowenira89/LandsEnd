class_name ObtainScreen extends Control
@onready var game: GridContainer = $MarginContainer/VBoxContainer/Game
@onready var fish: GridContainer = $MarginContainer/VBoxContainer/Fish
@onready var plants: GridContainer = $MarginContainer/VBoxContainer/Plants
@onready var game_label: Label = $MarginContainer/VBoxContainer/GameLabel
@onready var fish_label: Label = $MarginContainer/VBoxContainer/FishLabel
@onready var plants_label: Label = $MarginContainer/VBoxContainer/PlantsLabel

@onready var labels = [game_label,fish_label,plants_label]

var building:Camp
var unit:Unit
var district:District

func _update_menu():
	update_menu(district,building,unit)

func update_menu(d:District,b:Camp,u:Unit):
	building=b
	unit=u
	district=d
	for x in game.get_children():
		x.queue_free()
	for x in fish.get_children():
		x.queue_free()
	for x in plants.get_children():
		x.queue_free()
	
	for x in labels:
		x.visible=false
	if building:
		if building.hunt:
			game_label.visible=true
			for x in district.discovered_game:
				if x.kind!=Species.KIND.Fish:
					var button = Button.new()
					game.add_child(button)
					button.text=x.name
					button.pressed.connect(func(y=x.name):button_pressed.call(y))
		if building.fish:
			fish_label.visible=true
			for x in district.discovered_game:
				if x.kind == Species.KIND.Fish:
					var button = Button.new()
					fish.add_child(button)
					button.text=x.name
					button.pressed.connect(func(y=x.name):button_pressed.call(y))
		if building.forage:
			plants_label.visible=true
			for x in district.discovered_flora:
				var button = Button.new()
				plants.add_child(button)
				button.text=x.name
				button.pressed.connect(func(y=x.name):button_pressed.call(y))
	elif unit:
		game_label.visible=true
		for x in district.discovered_game:
			if x.kind!=Species.KIND.Fish:
				var button = Button.new()
				game.add_child(button)
				button.text=x.name
				button.pressed.connect(func(y=x.name):button_pressed.call(y))		
		fish_label.visible=true
		for x in district.discovered_game:
			if x.kind == Species.KIND.Fish:
				var button = Button.new()
				fish.add_child(button)
				button.text=x.name
				button.pressed.connect(func(y=x.name):button_pressed.call(y))
		plants_label.visible=true
		for x in district.discovered_flora:
			var button = Button.new()
			plants.add_child(button)
			button.text=x.name
			button.pressed.connect(func(y=x.name):button_pressed.call(y))
	GM.menus.switch_side_bottom(self)

func button_pressed(t:String):
	if building:
		GM.menus.switch_side_bottom(GM.menus.districts_view)
	elif unit:
		GM.menus.switch_side_bottom(GM.menus.unit_action_menu)
	for x in district.discovered_game:
		if x.name==t:
			GM.menus.send_data.emit(x)
			return
	for x in district.discovered_flora:
		if x.name==t:
			GM.menus.send_data.emit(x)
