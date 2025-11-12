class_name TerritoryTile extends Control

@export var data:Territory
@export var coords:Vector2i

@onready var button: TextureButton = $Button
@onready var frame: TextureRect = $Button/Frame


signal tile_clicked

const DESERT = "uid://brm3rxsdgbous"
const LAKE = "uid://d1arlbmma0rwg"
const RIVER = "uid://bvu1ssvjhxcup"
const ROCK = "uid://cqjwcjnl12bvm"
const SWAMP = "uid://bd1g4tjbgjkpq"

var images = [DESERT,LAKE,RIVER,ROCK,SWAMP]

func create(c:Vector2i):
	data=Territory.new()
	data.create(c)
	coords=c
	button.texture_normal=load(images.pick_random())


func _on_button_pressed() -> void:
	tile_clicked.emit(self)

func select():
	frame.visible=true
	
func unselect():
	frame.visible=false
