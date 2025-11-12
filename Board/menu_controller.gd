class_name MenuController extends CanvasLayer

@onready var side_menu: Control = $SideMenu
@onready var bottom_menu: Control = $BottomMenu
@onready var territory_stats: TerritoryStats = $SideMenu/ColorRect/MarginContainer/VBoxContainer/SideTop/TerritoryStats
@onready var district_stats: DistrictStats = $SideMenu/ColorRect/MarginContainer/VBoxContainer/SideTop/DistrictStats
@onready var build_menu: BuildMenu = $SideMenu/ColorRect/MarginContainer/VBoxContainer/SideTop/BuildMenu
@onready var districts_view: ColorRect = $SideMenu/ColorRect/MarginContainer/VBoxContainer/SideBottom/DistrictsView
@onready var stockpile_menu: StockpileMenu = $BottomMenu/ColorRect/MarginContainer/StockpileMenu
@onready var unit_view: NPCView = $SideMenu/ColorRect/MarginContainer/VBoxContainer/SideTop/UnitView
@onready var npc_view: ColorRect = $SideMenu/ColorRect/MarginContainer/VBoxContainer/SideTop/NPC_View

var previous_side_top
var previous_side_bottom
var current_side_top
var current_side_bottom

func _ready():
	GM.menus=self
	
func update_menus():
	current_side_top._update_menu()
	current_side_bottom._update_menu()

func switch_side_top(x):
	if current_side_top and current_side_top!=x:
		previous_side_top=current_side_top
	current_side_top=x
	x.move_to_front()
	x.visible=true
	
func switch_side_bottom(x):
	if current_side_bottom and current_side_bottom!=x:
		previous_side_bottom=current_side_bottom
	current_side_bottom=x
	x.move_to_front()

func hide_menus():
	side_menu.visible=false
	bottom_menu.visible=false

func show_territory(t:Territory):
	territory_stats.update_menu(t)
	districts_view.update_menu(t)
