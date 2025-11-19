class_name FarmView extends Control

@onready var fields_1: HBoxContainer = $MarginContainer/MarginContainer/HBoxContainer/VBoxContainer/Fields1
@onready var field_1: Button = $MarginContainer/MarginContainer/HBoxContainer/VBoxContainer/Fields1/Field1
@onready var field_2: Button = $MarginContainer/MarginContainer/HBoxContainer/VBoxContainer/Fields1/Field2
@onready var field_3: Button = $MarginContainer/MarginContainer/HBoxContainer/VBoxContainer/Fields1/Field3
@onready var fields_2: HBoxContainer = $MarginContainer/MarginContainer/HBoxContainer/VBoxContainer/Fields2
@onready var field_4: Button = $MarginContainer/MarginContainer/HBoxContainer/VBoxContainer/Fields2/Field4
@onready var field_5: Button = $MarginContainer/MarginContainer/HBoxContainer/VBoxContainer/Fields2/Field5
@onready var field_6: Button = $MarginContainer/MarginContainer/HBoxContainer/VBoxContainer/Fields2/Field6
@onready var ext_1: ExtentionButton = $MarginContainer/MarginContainer/HBoxContainer/Extentions/Ext1
@onready var ext_2: ExtentionButton = $MarginContainer/MarginContainer/HBoxContainer/Extentions/Ext2
@onready var ext_3: ExtentionButton = $MarginContainer/MarginContainer/HBoxContainer/Extentions/Ext3
@onready var ext_4: ExtentionButton = $MarginContainer/MarginContainer/HBoxContainer/Extentions/Ext4
@onready var field_7: Button = $MarginContainer/MarginContainer/HBoxContainer/VBoxContainer/HBoxContainer/Field7
@onready var field_8: Button = $MarginContainer/MarginContainer/HBoxContainer/VBoxContainer/HBoxContainer/Field8
@onready var field_9: Button = $MarginContainer/MarginContainer/HBoxContainer/VBoxContainer/HBoxContainer/Field9
@onready var prod_1: Button = $MarginContainer/MarginContainer/HBoxContainer/VBoxContainer/Production/Prod1
@onready var prod_2: Button = $MarginContainer/MarginContainer/HBoxContainer/VBoxContainer/Production/Prod2
@onready var prod_3: Button = $MarginContainer/MarginContainer/HBoxContainer/VBoxContainer/Production/Prod3
@onready var prod_4: Button = $MarginContainer/MarginContainer/HBoxContainer/VBoxContainer/Production2/Prod4
@onready var prod_5: Button = $MarginContainer/MarginContainer/HBoxContainer/VBoxContainer/Production2/Prod5
@onready var prod_6: Button = $MarginContainer/MarginContainer/HBoxContainer/VBoxContainer/Production2/Prod6

@onready var exts = [ext_1,ext_2,ext_3,ext_4]
@onready var fields = [field_1,field_2,field_3,field_4,field_5,field_6,field_7,field_8,field_9]
@onready var prods = [prod_1,prod_2,prod_3,prod_4,prod_5,prod_6]

var building:Farm

func _update_menu():
	update_menu(building)
	
func update_menu(b:Building):
	building=b
	for x in exts:
		x.visible=false
	for x in fields:
		x.visible=false
	for x in prods:
		x.visible=false	
	for x in building.extention_slots:
		exts[x].visible=true
		if building.extentions[x]:
			exts[x].create(building.extentions[x])
	for x in building.production_slots:
		prods[x].visible=true
		
