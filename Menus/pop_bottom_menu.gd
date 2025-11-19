class_name PopBottomMenu extends MarginContainer

var territory:Territory
@onready var friends: GridContainer = $PeopleBottomMenu/MarginContainer/VBoxContainer/Friends
@onready var foes: GridContainer = $PeopleBottomMenu/MarginContainer/VBoxContainer/Foes

const PERSON_SELECT = preload("res://Menus/PersonSelectButton.tscn")

func update_menu(t:Territory):
	territory=t
	for x in friends.get_children():
		x.queue_free()
	for x in foes.get_children():
		x.queue_free()
	for x in territory.units:
		if x.friendly:
			var icon = PERSON_SELECT.instantiate()
			friends.add_child(icon)
			icon.create(x.leader)
			icon.clicked.connect(show_unit_view)
	for x in territory.NPCs:
		if !x.unit:
			if x.friendly:
				var icon = PERSON_SELECT.instantiate()
				friends.add_child(icon)
				icon.create(x)
				icon.clicked.connect(show_unit_view)
	GM.menus.switch_side_bottom(self)

func show_unit_view(button):
	if button.person.unit:
		GM.menus.unit_action_menu.update_menu(button.person.unit)
		GM.menus.unit_view.update_menu(button.person.unit)

	
func _update_menu():
	update_menu(territory)
