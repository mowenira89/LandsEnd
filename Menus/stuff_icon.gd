class_name StuffIcon extends Control

signal remove
signal clicked
@onready var button: Button = $HBoxContainer/Button

func _on_button_pressed() -> void:
	clicked.emit(self)

func _on_x_pressed() -> void:
	remove.emit(self)
	
func create(s:String):
	button.text=s
