class_name PersonSelectorButton extends Button

@onready var texture_rect: TextureRect = $TextureRect

@export var _size:int

signal removing
signal open
var person
var unit
signal clicked

func create(p:Person):
	if _size:
		custom_minimum_size.x=_size
		custom_minimum_size.y=_size
		size.x=_size
		size.y=_size
	person=p
	if person:
		texture_rect.texture=person.image
	if p:
		texture_rect.visible=true
	else:
		texture_rect.visible=false
		
func _on_texture_rect_gui_input(event: InputEvent) -> void:
	if event.is_action_released("Right Click"):
		removing.emit(self)
	if event.is_action_released("Click"):
		clicked.emit(self)

func _on_pressed() -> void:
	open.emit(self)

func reset():
	person=null
	texture_rect.visible=false
