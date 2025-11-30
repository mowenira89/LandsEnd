class_name ItemSelectMenu extends Control
@onready var grid: GridContainer = $MarginContainer/MarginContainer/HBoxContainer/grid

signal emit_stuff

var index:int

func create(items:Array[Stuff],index:int):
	for x in grid.get_children():
		x.queue_free()
	for x in items:
		var button = Button.new()
		grid.add_child(button)
		button.text=x.name
		button.pressed.connect(receive_data)
		
		
func receive_data(s:String):
	var stuff = RM.stuff[s]
	emit_stuff.emit(stuff,index)
	
