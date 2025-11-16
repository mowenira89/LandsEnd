class_name PersonSelectorButton extends Button

@onready var texture_rect: TextureRect = $TextureRect

signal removing
signal open
var person
var unit
signal clicked

func create(u:Unit=null, p:Person=null):
	if u:
		unit=u
	elif p:
		person=p
	if unit:
		texture_rect.texture=unit.leader.image
	elif person:
		texture_rect.texture=person.image
	if u or p:
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
