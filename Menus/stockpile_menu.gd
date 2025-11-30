class_name StockpileMenu extends MarginContainer

var territory:Territory
var setting="Storeroom"
const RED_GREEN_BUTTON = preload("uid://6ksjvhk3tld")

@onready var grid: GridContainer = $StockpileMenu/MarginContainer/VBoxContainer/ScrollContainer/VBoxContainer/Grid

func update_menu(t:Territory):
	if t or territory:
		territory=t
		set_menu()
	
func _update_menu():
	update_menu(territory)
	
func alter_useage(x):
	territory.stockpile.alter_usage(x)
	
			
func set_menu():
	for x in grid.get_children():
		x.queue_free()
	var a
	match setting:
		"Storeroom":
			a=territory.stockpile.storeroom_order
		"Food":
			a=territory.stockpile.food_order
		"Animals":
			a=territory.stockpile.animal_order
	for x in a:
		var button = RED_GREEN_BUTTON.instantiate()
		grid.add_child(button)
		var s = x.name+" "+str(int(territory.stockpile.check_stuff_amount(x)))
		var b = false if x in territory.stockpile.prohibited else true
		button.create(s,b)
		button.right_clicked.connect(get_contents)
		
func get_contents(x:String):
	var s = x.split(" ") as Array[String]
	s.pop_at(s.size()-1)
	var ss=""
	for y in s:
		ss+=y+" "
	ss=ss.strip_edges(false,true)
	var stuff = RM.stuff[ss]
	territory.stockpile.alter_useage(stuff)
	_update_menu()
		
func _on_storeroom_button_pressed() -> void:
	setting="Storeroom"
	_update_menu()

func _on_granary_button_pressed() -> void:
	setting="Food"
	_update_menu()

func _on_animals_button_pressed() -> void:
	setting="Animals"
	_update_menu()
