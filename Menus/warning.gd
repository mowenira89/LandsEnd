class_name AWarning extends ColorRect

@onready var message: RichTextLabel = $MarginContainer/VBoxContainer/Message
@onready var ok: Button = $MarginContainer/VBoxContainer/HBoxContainer/OK
@onready var no: Button = $MarginContainer/VBoxContainer/HBoxContainer/No

signal response

func create(m:String,b1:String="OK",b2:String="No"):
	message.text=m
	ok.text=b1
	no.text=b2
	visible=true


func _on_ok_pressed() -> void:
	response.emit(true)
	visible=false
	


func _on_no_pressed() -> void:
	response.emit(false)
	visible=false
