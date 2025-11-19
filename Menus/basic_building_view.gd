class_name BasicBuildingView extends ColorRect

var building:Building
@onready var boss: PersonSelectorButton = $MarginContainer/HBoxContainer/VBoxContainer3/Boss
@onready var extentions: VBoxContainer = $MarginContainer/HBoxContainer/Extentions

@onready var label: Label = $MarginContainer/HBoxContainer/VBoxContainer/Label
@onready var label_2: Label = $MarginContainer/HBoxContainer/VBoxContainer/Label2

@onready var ext1: ExtentionButton = $MarginContainer/HBoxContainer/Extentions/ExtentionButton
@onready var ext2: ExtentionButton = $MarginContainer/HBoxContainer/Extentions/ExtentionButton2
@onready var ext3: ExtentionButton = $MarginContainer/HBoxContainer/Extentions/ExtentionButton3
@onready var ext4: ExtentionButton = $MarginContainer/HBoxContainer/Extentions/ExtentionButton4

@onready var prod_1: ProductionContainer = $MarginContainer/HBoxContainer/VBoxContainer/HBoxContainer/ProductionContainers/VBoxContainer/HBoxContainer/Prod1
@onready var prod_2: ProductionContainer = $MarginContainer/HBoxContainer/VBoxContainer/HBoxContainer/ProductionContainers/VBoxContainer/HBoxContainer/Prod2
@onready var prod_3: ProductionContainer = $MarginContainer/HBoxContainer/VBoxContainer/HBoxContainer/ProductionContainers/VBoxContainer/HBoxContainer2/Prod3
@onready var prod_4: ProductionContainer = $MarginContainer/HBoxContainer/VBoxContainer/HBoxContainer/ProductionContainers/VBoxContainer/HBoxContainer2/Prod4
@onready var prod_5: ProductionContainer = $MarginContainer/HBoxContainer/VBoxContainer/HBoxContainer/ProductionContainers/VBoxContainer/HBoxContainer3/Prod5
@onready var prod_6: ProductionContainer = $MarginContainer/HBoxContainer/VBoxContainer/HBoxContainer/ProductionContainers/VBoxContainer/HBoxContainer3/Prod6
@onready var prods = [prod_1,prod_2,prod_3,prod_4,prod_5,prod_6]
@onready var extention_buttons = [ext1,ext2,ext3,ext4]
const PRODUCTION_SLOT = preload("res://Menus/production_container.tscn")

func _ready():
	for x in 6:
		prods[x].index=x
	call_deferred("connect_signal")

func update_menu(b:Building):
	building = b	
	var s = building.district.territory.name+" District "+str(building.district.index)+" "+building.name
	label.text=s
	label_2.text = District.TYPES.keys()[building.district.type]
	
	
	for x in prods:
		x.visible=false
	for x in building.production_slots:
		prods[x].visible=true
		var options:Array[String] = building.get_production_options()
		prods[x].create(building,x,options)
	for x in extention_buttons:
		x.visible=false
	for x in building.extention_slots:
		extention_buttons[x].visible=true
	boss.create(building.boss)
		
	GM.menus.switch_side_top(self)
	
func _update_menu():
	update_menu(building)
