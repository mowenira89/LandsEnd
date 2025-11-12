class_name Board extends Node2D

@onready var water: TileMapLayer = $Water
@onready var ground: TileMapLayer = $Ground

const TERRITORY_TILE = preload("res://Board/territory_tile.tscn")
@onready var menus: MenuController = $Menus

var tiles_by_cell = {}

@onready var camera: Camera = $Camera2D
@onready var territories: Node2D = $Territories

var panning:bool=false

var currently_selected:TerritoryTile

func _ready():
	create()
	GM.board=self
	

func create():
	var coords = ground.get_used_cells()
	for x in coords:
		var new_tile = TERRITORY_TILE.instantiate()
		territories.add_child(new_tile)
		new_tile.create(x)
		tiles_by_cell[x]=new_tile
		var pos = ground.map_to_local(x)-Vector2(60,60)
		new_tile.position=pos	
		new_tile.tile_clicked.connect(territory_button_clicked)
		
func territory_button_clicked(t:TerritoryTile):
	if currently_selected:
		currently_selected.unselect()
	currently_selected=t
	t.select()
	menus.show_territory(t.data)
	
	

func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("Middle Click"):	
		panning=true
	if event.is_action_released("Middle Click"):
		panning=false
	if panning and event is InputEventMouseMotion:
		camera.global_position+=-event.relative

func center_camera(cell:Vector2i):
	camera.position=ground.map_to_local(cell)+Vector2(250,100)


func set_camera_bounds():
	var c = water.get_used_rect()
	camera.limit_bottom=c.size.y
	camera.limit_left=c.position.x
	camera.limit_right=c.size.x
	camera.limit_top=c.position.y
