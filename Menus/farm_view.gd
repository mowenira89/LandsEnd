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


@onready var prod_1: ProductionContainer = $MarginContainer/MarginContainer/HBoxContainer/VBoxContainer2/Production/ProductionContainer
@onready var prod_2: ProductionContainer = $MarginContainer/MarginContainer/HBoxContainer/VBoxContainer2/Production/ProductionContainer2
@onready var prod_3: ProductionContainer = $MarginContainer/MarginContainer/HBoxContainer/VBoxContainer2/Production/ProductionContainer3
@onready var prod_4: ProductionContainer = $MarginContainer/MarginContainer/HBoxContainer/VBoxContainer2/Production/ProductionContainer4
@onready var prod_5: ProductionContainer = $MarginContainer/MarginContainer/HBoxContainer/VBoxContainer2/Production/ProductionContainer5
@onready var prod_6: ProductionContainer = $MarginContainer/MarginContainer/HBoxContainer/VBoxContainer2/Production/ProductionContainer6
@onready var button: Label = $MarginContainer/MarginContainer/HBoxContainer/VBoxContainer/Fields1/Field1/Button
@onready var button_2: Label = $MarginContainer/MarginContainer/HBoxContainer/VBoxContainer/Fields1/Field2/Button
@onready var button_3: Label = $MarginContainer/MarginContainer/HBoxContainer/VBoxContainer/Fields1/Field3/Button
@onready var button_4: Label = $MarginContainer/MarginContainer/HBoxContainer/VBoxContainer/Fields2/Field4/Button
@onready var button_5: Label = $MarginContainer/MarginContainer/HBoxContainer/VBoxContainer/Fields2/Field5/Button
@onready var button_6: Label = $MarginContainer/MarginContainer/HBoxContainer/VBoxContainer/Fields2/Field6/Button
@onready var button_7: Label = $MarginContainer/MarginContainer/HBoxContainer/VBoxContainer/HBoxContainer/Field7/Button
@onready var button_8: Label = $MarginContainer/MarginContainer/HBoxContainer/VBoxContainer/HBoxContainer/Field8/Button
@onready var button_9: Label = $MarginContainer/MarginContainer/HBoxContainer/VBoxContainer/HBoxContainer/Field9/Button


@onready var exts = [ext_1,ext_2,ext_3,ext_4]
@onready var fields = [field_1,field_2,field_3,field_4,field_5,field_6,field_7,field_8,field_9]
@onready var prods = [prod_1,prod_2,prod_3,prod_4,prod_5,prod_6]
@onready var warnings = [button,button_2,button_3,button_4,button_5,button_6,button_7,button_8,button_9]

var building:Farm

func _update_menu():
	update_menu(building)
	
func _ready():
	for x in fields:
		x.pressed.connect(open_field.bind(x))
	
	
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
		prods[x].create(building,x,building.get_production_options())
	for x in building.get_fields():
		fields[x].visible=true
		warnings[x].visible=false
		if building.crops[x]!=null:
			fields[x].text=building.crops[x].name
		elif building.livestock[x]!=null:
			fields[x].text=building.livestock[x].species.name
			var food = building.livestock[x].food
			if building.livestock[x].species.diet==Species.DIET.Herbivore and GM.month not in GM.winter:
				warnings[x].visible=false
			else:
				if !food:
					warnings[x].visible=true
				else:
					var amt = building.district.territory.stockpile.check_stuff_amount(food)
					if amt == 0:
						warnings[x].visible=true
				
		else:
			fields[x].text="Fallow"
	GM.menus.switch_side_top(self)
	
func open_recipe_menu(i:int):
	GM.menus.recipe_menu.update_menu(building,i)

func open_field(b:Button):
	var index = fields.find(b)
	if building.crops[index] is Crop:
		GM.menus.crop_stat_view.update_menu(building.crops[index],building)
	elif building.livestock[index] is Herd:
		GM.menus.crop_stat_view.update_menu(building.livestock[index],building)
	else:
		GM.menus.crop_select_screen.update_menu(building)
		var choice = await GM.menus.send_data
		if choice is Crop:
			building.set_crop(choice,index)
		elif choice is Species:
			building.set_livestock(choice,index)
	GM.menus.update_menus()
