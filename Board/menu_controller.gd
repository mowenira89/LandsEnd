class_name MenuController extends CanvasLayer

@onready var side_menu: Control = $SideMenu
@onready var bottom_menu: Control = $BottomMenu
@onready var territory_stats: TerritoryStats = $SideMenu/ColorRect/MarginContainer/VBoxContainer/SideTop/TerritoryStats
@onready var district_stats: DistrictStats = $SideMenu/ColorRect/MarginContainer/VBoxContainer/SideTop/DistrictStats
@onready var build_menu: BuildMenu = $SideMenu/ColorRect/MarginContainer/VBoxContainer/SideTop/BuildMenu
@onready var districts_view: DistrictsView = $SideMenu/ColorRect/MarginContainer/VBoxContainer/SideBottom/DistrictsView
@onready var stockpile_menu: StockpileMenu = $BottomMenu/ColorRect/MarginContainer/StockpileMenu
@onready var unit_view: UnitView = $SideMenu/ColorRect/MarginContainer/VBoxContainer/SideTop/UnitView
@onready var npc_view: NPCView = $SideMenu/ColorRect/MarginContainer/VBoxContainer/SideTop/NPC_View
@onready var create_unit: CreateUnitScreen = $CreateUnit
@onready var top_menu: TopMenu = $TopMenu
@onready var pop_bottom_menu: PopBottomMenu = $SideMenu/ColorRect/MarginContainer/VBoxContainer/SideBottom/PopBottomMenu
@onready var basic_building_view: BasicBuildingView = $SideMenu/ColorRect/MarginContainer/VBoxContainer/SideTop/BasicBuildingView
@onready var recipe_menu: RecipeMenu = $SideMenu/ColorRect/MarginContainer/VBoxContainer/SideBottom/RecipeMenu
@onready var unit_action_menu: UnitActionMenu = $SideMenu/ColorRect/MarginContainer/VBoxContainer/SideBottom/UnitActionMenu
@onready var exchange_window: ExchangeWindow = $SideMenu/ColorRect/MarginContainer/VBoxContainer/SideBottom/ExchangeWindow
@onready var building_view_bottom: Control = $SideMenu/ColorRect/MarginContainer/VBoxContainer/SideBottom/BuildingViewBottom


@onready var alert: ColorRect = $Alert
@onready var alert_label: Label = $Alert/AlertLabel
@onready var end_turn_box: EndTurnBox = $EndTurnBox



@onready var land: Button = $SideMenu/ColorRect/MarginContainer/VBoxContainer/TopButtons/Land
@onready var people: Button = $SideMenu/ColorRect/MarginContainer/VBoxContainer/TopButtons/People
@onready var events: Button = $SideMenu/ColorRect/MarginContainer/VBoxContainer/TopButtons/Events
@onready var population: Button = $SideMenu/ColorRect/MarginContainer/VBoxContainer/PeopleButtons/Population
@onready var individuals: Button = $SideMenu/ColorRect/MarginContainer/VBoxContainer/PeopleButtons/Individuals

@onready var buttons = [land, people, events, population, individuals]


var previous_side_top
var previous_side_bottom
var current_side_top
var current_side_bottom



func _ready():
	GM.menus=self
	
func update_menus():
	if current_side_top:
		current_side_top._update_menu()
	if current_side_bottom:
		current_side_bottom._update_menu()
	if top_menu.territory:
		top_menu._update_menu()

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
	x.visible=true
	

func hide_menus():
	side_menu.visible=false
	bottom_menu.visible=false
	top_menu.visible=false

func show_territory(t:Territory):
	territory_stats.update_menu(t)
	districts_view.update_menu(t)
	top_menu.update_menu(t)


func _on_land_pressed() -> void:
	territory_stats._update_menu()
	districts_view._update_menu()
	top_menu._update_menu()

func _on_people_pressed() -> void:
	pop_bottom_menu.update_menu(GM.board.currently_selected.data)

func _on_events_pressed() -> void:
	pass # Replace with function body.


func _on_form_party_pressed() -> void:
	create_unit.update_menu(GM.board.currently_selected.data)
	create_unit.new_party(null)

func update_pop_hud():
	top_menu._update_menu()

func disable_buttons():
	for x in buttons:
		x.disabled=true

func enable_buttons():
	for x in buttons:
		x.disabled=false


func _on_end_turn_pressed() -> void:
	GM.end_turn()

func show_alert(m:String):
	alert_label.text=m
	alert.visible=true
	await get_tree().create_timer(2).timeout
	alert.visible=false
