class_name TopMenu extends ColorRect

@onready var week: Label = $MarginContainer/HBoxContainer/VBoxContainer/Week
@onready var month: Label = $MarginContainer/HBoxContainer/VBoxContainer/Month
@onready var pop_hud: PopHud = $MarginContainer/HBoxContainer/PopHud

var territory:Territory

func update_menu(t:Territory):
	territory=t
	pop_hud.update_menu(territory)
	week.text="Week "+str(GM.week)
	month.text = GM.MONTHS.keys()[GM.month]
	visible=true
	
func _update_menu():
	update_menu(territory)
	
