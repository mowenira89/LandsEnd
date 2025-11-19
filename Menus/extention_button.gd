class_name ExtentionButton extends Button

@onready var texture_rect: TextureRect = $TextureRect

signal removing
signal open
var data
signal clicked

@export var _size:int

func _ready():
	custom_minimum_size.y=_size
	custom_minimum_size.x=_size
		
func create(b:Building):
	data=b
	if data:
		texture_rect.visible=true
		texture_rect.texture=data.image
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
	data=null
	texture_rect.visible=false
