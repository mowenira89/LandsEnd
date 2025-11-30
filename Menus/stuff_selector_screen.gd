class_name StuffSelectorScreen extends Control

@onready var collection: VBoxContainer = $MarginContainer/ColorRect/MarginContainer/ScrollContainer/Collection
var stuff:Array[Stuff]
@onready var item_name: Label = $MarginContainer/ColorRect/MarginContainer/VBoxContainer/ItemName
@onready var details: VBoxContainer = $MarginContainer/ColorRect/MarginContainer/VBoxContainer/Details

func update_menu(s:Array[Stuff]):
	GM.menus.send_data.emit(null)
	stuff = s
	for x in collection.get_children():
		x.queue_free()
	for x in stuff:
		var button = Button.new()
		collection.add_child(button)
		button.text=x.name
		button.pressed.connect(func(y=button):on_press.call(y.text))
		button.mouse_entered.connect(func(y=button):on_mouseover.call(y))
	GM.menus.switch_side_bottom(self)

func _update_menu():
	update_menu(stuff)
	
func on_mouseover(b:Button):
	item_name.text=b.text
	var item = RM.stuff[b.text]
	for x in details.get_children():
		x.queue_free()
	for x in item.qualities:
		var n = Label.new()
		details.add_child(n)
		var s = Stuff.QUALITIES.keys()[x]+" "+str(int(item.qualities[x]))
		n.text=s

func on_press(t:String):
	
	GM.menus.switch_side_bottom(GM.menus.previous_side_bottom)
	GM.menus.send_data.emit(t)


func _on_button_pressed() -> void:
	GM.menus.send_data.emit(null)
