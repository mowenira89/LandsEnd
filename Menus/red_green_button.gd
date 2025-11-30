class_name RedGreenButton extends MarginContainer
@onready var color_rect: ColorRect = $ColorRect

@onready var label: Label = $Label

signal clicked
signal right_clicked

func create(t:String,b:bool):
	label.text=t
	if b:
		color_rect.color=GM.GREEN
	else:
		color_rect.color=GM.RED


func _on_gui_input(event: InputEvent) -> void:
	if event.is_action_released("Click"):
		clicked.emit(label.text)
	if event.is_action_released("Right Click"):
		right_clicked.emit(label.text)
