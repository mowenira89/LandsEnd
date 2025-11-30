class_name DedicationSelectorButton extends Button

signal removing
signal open
var data
@export var _size:int=75
@onready var texture_rect: TextureRect = $TextureRect

var _disabled:bool=false

const converter = {
	Stuff.MYSTIC.Sylvan:"Spirits\nof the\nForest",
	Stuff.MYSTIC.Cthonic:"Cthonic\nSpirits",
	Stuff.MYSTIC.Fire:"Spirits\nof Flame",
	Stuff.MYSTIC.Water:"Spirits of\nthe Fountain",
	Stuff.MYSTIC.Air:"Spirits of\nthe Air",
	Stuff.MYSTIC.Divine:"Spirits of the\nQuintessence",
	Stuff.MYSTIC.Eldrich:"Spirits of \nthe Unknown"
}



func _ready():
	removing.connect(reset)
	custom_minimum_size.y=_size
	custom_minimum_size.x=_size
		
func create(s):
	data=s
	if data is Stuff.MYSTIC:
		text=converter[data]
		add_theme_font_size_override("font_size",16)
		texture_rect.visible=false
	elif data is Person:
		texture_rect.visible=true
		texture_rect.texture=data.image
	else:
		text="+"
		add_theme_font_size_override("font_size",44)
		texture_rect.visible=false

func reset():
	data=null


func _on_gui_input(event: InputEvent) -> void:
	if event.is_action_released("Right Click") and !disabled:
		removing.emit(self)


func _on_pressed() -> void:
	if  !disabled:
		open.emit()

func _on_texture_rect_gui_input(event: InputEvent) -> void:
	if event.is_action_released("Right Click") and !disabled:
		removing.emit(self)
