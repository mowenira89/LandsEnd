class_name Board extends Node2D

@onready var water: TileMapLayer = $Water
@onready var ground: TileMapLayer = $Ground

const TERRITORY_TILE = preload("res://Board/territory_tile.tscn")
@onready var menus: MenuController = $Menus
@onready var end_turn_box: EndTurnBox = $Menus/EndTurnBox

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
	#Coordinates of tiles on tilemap layer, new territory resource created for each
	#Assigned to tiles_by_cell dictionary used to access territories when needed
	#especially for movement. 
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
		
	#Update tile will change based on some buildings in the territory
	#and whether there is a NPC in the territory. The x represents an NPC
		
func territory_button_clicked(t:TerritoryTile):
	if currently_selected:
		currently_selected.unselect()
	currently_selected=t
	t.select()
	menus.show_territory(t.data)
	center_camera(t.data.coords)
	
	#receives data from the clicked territory tile which holds its Territory resource
	#Show menu shows the starter menus

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
	GM.menus.send_data.emit(array[0])
	
	#the cell coords are held in the territory, used to get surrounding tiles, 
	#data can be handled from there. the board is disabled so that only the  
	#this is awaited by the unit_action_menu when move is selected. 

	#disabled board is used to make sure the player doesnt click something while
	#an input is needed
func disable_board():
	for x in tiles_by_cell.values():
		x.disable()
	GM.menus.disable_buttons()
		
func enable_board():
	for x in tiles_by_cell.values():
		x.enable()
	GM.menus.enable_buttons()
