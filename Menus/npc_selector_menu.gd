class_name NPCSelectorMenu extends Control

var territory:Territory
var mode:String

@onready var idle_grid: GridContainer = $MarginContainer/VBoxContainer/IdleGrid
@onready var busy_grid: GridContainer = $MarginContainer/VBoxContainer/BusyGrid
@onready var military_grid: GridContainer = $MarginContainer/VBoxContainer/MilitaryGrid
@onready var foes_grid: GridContainer = $MarginContainer/VBoxContainer/FoesGrid

@onready var grids = [idle_grid,busy_grid,military_grid,foes_grid]

func update_menu(t:Territory,m:String,c:Pop.CLASS=-1,exclude:Person=null):
	territory=t
	mode=m
	for x in grids:
		for y in x.get_children():
			y.queue_free()
	var potential = territory.NPCs.duplicate()
	if mode=="Foes":
		for x in potential.duplicate():
			if x.get_friendliness():
				potential.erase(x)
	if mode=="NewBoss":
		for x in potential.duplicate():
			if x.boss_of != null:
				potential.erase(x)
			if x.in_building:
				potential.erase(x)
			if x.CLASS!=c:
				potential.erase(x)
	if c>-1:
		for x in potential.duplicate():
			if x.CLASS!=c:
				potential.erase(x)
	if mode=="Idle":
		for x in potential.duplicate():
			if x is MilitaryUnit:
				potential.erase(x)
			if x.in_building:
				potential.erase(x)
			if !x.get_friendliness():
				potential.erase(x)
	if exclude in potential:
		potential.erase(exclude)
				
	for x in potential:
		var button = TextureButton.new()
		if !x.get_friendliness():
			foes_grid.add_child(button)
			button.pressed.connect(get_selection.bind(x))
		elif x.in_building:
			busy_grid.add_child(button)
			button.pressed.connect(see_building.bind(x))
		elif x is MilitaryUnit:
			military_grid.add_child(button)
			button.pressed.connect(get_selection.bind(x))
		else:
			idle_grid.add_child(button)
			button.pressed.connect(get_selection.bind(x))
		button.ignore_texture_size=true
		button.custom_minimum_size=Vector2(75,75)
		button.stretch_mode=TextureButton.STRETCH_SCALE
		button.texture_normal = x.image
		

	GM.menus.switch_side_bottom(self)

func _update_menu():
	update_menu(territory,mode)

func get_selection(u:Person):
	GM.menus.send_data.emit(u)

func see_building(u:Person):
	u.in_building.get_menu()
	

func _on_button_pressed() -> void:
	GM.menus.send_data.emit(null)
