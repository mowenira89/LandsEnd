class_name BuildingViewBottom extends Control

var building:Building

@onready var event_viewer: VBoxContainer = $MarginContainer/ColorRect/MarginContainer/HBoxContainer/MarginContainer/VBoxContainer/ScrollContainer/EventViewer


func _update_menu():
	update_menu(building)

func update_menu(b:Building):
	building=b
	for x in event_viewer.get_children():
		x.queue_free()
	for x in building.memories:
		var label=Label.new()
		event_viewer.append(label)
		label.text=x.memory
	
