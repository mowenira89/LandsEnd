class_name FeedSelectScreen extends Control
@onready var grid: GridContainer = $MarginContainer/grid

var stockpile:Stockpile
var herd:Herd

func _update_menu():
	update_menu(herd,stockpile)

func update_menu(h:Herd,s:Stockpile):
	herd=h
	stockpile=s
	for x in grid.get_children():
		x.queue_free()
	for x:Stuff in stockpile.stuff.keys():
		if herd.species.diet in x.diet_type and x.qualities.has(Stuff.QUALITIES.Feed):
			var button = Button.new()
			grid.add_child(button)
			button.text=x.name
			var stuff = RM.stuff[x.name]
			print(stuff)
			button.pressed.connect(func(y=stuff):GM.menus.send_data.emit(y))
			
	GM.menus.switch_side_bottom(self)
			
