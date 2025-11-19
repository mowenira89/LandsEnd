class_name StuffSelectorScreen extends Control

@onready var collection: VBoxContainer = $MarginContainer/ColorRect/MarginContainer/ScrollContainer/CenterContainer/Collection

var stuff:Array[Stuff]

signal send_stuff

func update_menu(s:Array[Stuff]):
	stuff = s
	for x in collection.get_children():
		x.queue_free()
	for x in stuff:
		var button = Button.new()
		collection.add_child(button)
		button.text=x.name
		button.pressed.connect(func(y=button):send_stuff.emit.bind(y.text))
