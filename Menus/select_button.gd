class_name SelectorButton extends Button

@onready var texture_rect: TextureRect = $TextureRect

signal removing
signal open
var data
signal clicked
@export var _size:int

func _ready():
	removing.connect(reset)
	custom_minimum_size.y=_size
	custom_minimum_size.x=_size
		
func create(s:Stuff):
	data=s
	text=data.name
	if data:
		text=data.name
		add_theme_font_size_override("font_size",16)
	else:
		text="+"
		add_theme_font_size_override("font_size",44)
		
		
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
