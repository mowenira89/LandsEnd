class_name DedicationSelectWindow extends Control

var territory:Territory
@onready var grid: GridContainer = $MarginContainer/MarginContainer/VBoxContainer/Grid

const PERSON_SELECT = preload("res://Menus/PersonSelectButton.tscn")

var building:Temple
var unit:Unit

func _update_menu():
	update_menu(building,unit)

func update_menu(b:Temple=null,u:Unit=null):
	if b:
		territory=b.district.territory
	elif u:
		territory=u.current_territory
	building=b
	unit=u
	for x in grid.get_children():
		x.queue_free()
	
	if building:
		if !b.dedication and !b.dedicated_lesser:
			set_lesser()
		elif b.dedicated_lesser and !b.dedication:
			set_greater()
	elif unit:
		set_lesser()
		set_greater()
				
	GM.menus.switch_side_bottom(self)
				
func set_lesser():
	for x in MagicManager.lesser_spirits:
		var new = Button.new()
		grid.add_child(new)
		new.text=MagicManager.lesser_spirits[x].title
		new.pressed.connect(func(y=x):GM.menus.send_data.emit.call(y))
			
func set_greater():
	for x in territory.NPCs:
		if x.CLASS==Pop.CLASS.Nymphoi and building.spirit_dedication in x.affinity:
			var button = PERSON_SELECT.instantiate()
			grid.add_child(button)
			button.create(x)
			button.clicked.connect(recieve_info)
			
			
func recieve_info(b:DedicationSelectorButton):
	GM.menus.send_data.emit(b.data)
