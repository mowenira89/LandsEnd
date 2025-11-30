class_name TerritoryTile extends Control

@export var data:Territory
@export var coords:Vector2i

@onready var button: TextureButton = $Button
@onready var frame: TextureRect = $Button/Frame
@onready var selector_button: TextureButton = $SelectorButton

@onready var travelers: TextureRect = $Travelers


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
	selector_button.texture_normal=button.texture_normal
	selector_button.self_modulate="#5e56c3"
	selector_button.visible=false



func update_tile():
	travelers.visible=false
	if !data.units.is_empty():
		travelers.visible=true
	elif !data.NPCs.is_empty():
		travelers.visible=true

func _on_button_pressed() -> void:
	GM.menus.send_data.emit(null)
	tile_clicked.emit(self)

func disable():
	button.disabled=true
	
func enable():
	button.disabled=false

func select():
	frame.visible=true
	
func unselect():
	frame.visible=false

func set_for_targeting():
	selector_button.visible=true
	GM.board.disable_board()
	
func untarget():
	selector_button.visible=false
	GM.board.enable_board()


func _on_selector_button_gui_input(event: InputEvent) -> void:
	if event.is_action_released("Click"):
		GM.select_territory.emit(data,true)
	elif event.is_action_released("Right Click"):
		GM.select_territory.emit(null,false)
