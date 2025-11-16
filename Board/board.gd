class_name Board extends Node2D

@onready var water: TileMapLayer = $Water
@onready var ground: TileMapLayer = $Ground

const TERRITORY_TILE = preload("res://Board/territory_tile.tscn")
@onready var menus: MenuController = $Menus
@onready var screen: ColorRect = $Menus/Screen

var tiles_by_cell:Dictionary[Vector2i,TerritoryTile] = {}

@onready var camera: Camera = $Camera2D
@onready var territories: Node2D = $Territories

var panning:bool=false

var currently_selected:TerritoryTile
var can_zoom:bool=true

func _ready():
	create()
	GM.board=self
	GM.start_new_game()

func create():
	var coords = ground.get_used_cells()
	for x in coords:
		var new_tile = TERRITORY_TILE.instantiate()
		territories.add_child(new_tile)
		new_tile.create(x)
		tiles_by_cell[x]=new_tile
		var pos = ground.map_to_local(x)
		new_tile.position=pos	
		new_tile.tile_clicked.connect(territory_button_clicked)
	
func update_board():
	for x in tiles_by_cell.values():
		x.update_tile()
		
func territory_button_clicked(t:TerritoryTile):
	if currently_selected:
		currently_selected.unselect()
	currently_selected=t
	t.select()
	menus.show_territory(t.data)
	center_camera(t.data.coords)
	

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

func get_target_territory(t:Territory,unit:Unit):
	var surrounding = ground.get_surrounding_cells(t.coords)
	for x in surrounding:
		if x in tiles_by_cell.keys():
			tiles_by_cell[x].set_for_targeting()
	GM.board.disable_board()
	var array = await GM.select_territory
	for x in surrounding:
		if x in tiles_by_cell.keys():
			tiles_by_cell[x].untarget()
	return array[0]

func disable_board():
	for x in tiles_by_cell.values():
		x.disable()
		
func enable_board():
	for x in tiles_by_cell.values():
		x.enable()


func _on_side_menu_mouse_entered() -> void:
	can_zoom=false
	screen.visible=true
func _on_side_menu_mouse_exited() -> void:
	can_zoom=true
	screen.visible=true

func _on_screen_mouse_entered() -> void:
	can_zoom=true
	screen.visible=false
