class_name SelectorButton extends Button

signal removing
signal open
var data
@export var _size:int=75

func _ready():
	removing.connect(reset)
	custom_minimum_size.y=_size
	custom_minimum_size.x=_size
		
func create(s:Stuff):
	data=s
	if data:
		text=data.name
		add_theme_font_size_override("font_size",16)
	else:
		text="+"
		add_theme_font_size_override("font_size",44)
		

func _on_pressed() -> void:
	open.emit(self)
	var s = await GM.menus.send_data
	if s is Stuff:
		create(s)
	elif s is String:
		create(RM.stuff[s])

func reset():
	data=null


func _on_gui_input(event: InputEvent) -> void:
	if event.is_action_released("Right Click"):
		removing.emit(self)
