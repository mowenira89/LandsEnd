class_name TempleMenu extends Control

var building:Temple
@onready var dedication: DedicationSelectorButton = $MarginContainer/ColorRect/MarginContainer/VBoxContainer/HBoxContainer/VBoxContainer3/Dedication
@onready var dedication_info: RichTextLabel = $MarginContainer/ColorRect/MarginContainer/VBoxContainer/HBoxContainer/DedicationInfo


@onready var music: SelectorButton = $MarginContainer/ColorRect/MarginContainer/VBoxContainer/HBoxContainer/BonusHolder/Music
@onready var incense: SelectorButton = $MarginContainer/ColorRect/MarginContainer/VBoxContainer/HBoxContainer/BonusHolder/Incense
@onready var fuel: SelectorButton = $MarginContainer/ColorRect/MarginContainer/VBoxContainer/HBoxContainer/BonusHolder/Fuel
@onready var music_label: Label = $MarginContainer/ColorRect/MarginContainer/VBoxContainer/HBoxContainer/BonusHolder/MusicLabel
@onready var incense_label: Label = $MarginContainer/ColorRect/MarginContainer/VBoxContainer/HBoxContainer/BonusHolder/IncenseLabel
@onready var fuel_label: Label = $MarginContainer/ColorRect/MarginContainer/VBoxContainer/HBoxContainer/BonusHolder/FuelLabel

@onready var prod_1: ProductionContainer = $MarginContainer/ColorRect/MarginContainer/VBoxContainer/HBoxContainer/ProdContainers/prod1
@onready var prod_2: ProductionContainer = $MarginContainer/ColorRect/MarginContainer/VBoxContainer/HBoxContainer/ProdContainers/prod2
@onready var prod_3: ProductionContainer = $MarginContainer/ColorRect/MarginContainer/VBoxContainer/HBoxContainer/ProdContainers/prod3
@onready var prod_4: ProductionContainer = $MarginContainer/ColorRect/MarginContainer/VBoxContainer/HBoxContainer/ProdContainers/prod4
@onready var prod_5: ProductionContainer = $MarginContainer/ColorRect/MarginContainer/VBoxContainer/HBoxContainer/ProdContainers/prod5
@onready var prod_6: ProductionContainer = $MarginContainer/ColorRect/MarginContainer/VBoxContainer/HBoxContainer/ProdContainers/prod6

@onready var prods = [prod_1,prod_2,prod_3,prod_4,prod_5,prod_6] 

@onready var ritual_1: Button = $MarginContainer/ColorRect/MarginContainer/VBoxContainer/Ritual1
@onready var ritual_2: Button = $MarginContainer/ColorRect/MarginContainer/VBoxContainer/Ritual2


func update_menu(b:Temple):
	building=b
	
	if building.dedicated_lesser:
		dedication.create(building.spirit_dedication)
	else:
		dedication.create(building.dedication)
	
	incense.create(building.incense)
	music.create(building.music)
	if building.level<5:
		music.visible=false
		music_label.visible=false
	else:
		music.visible=true
		music_label.visible=true
	if building.level<2:
		incense.visible=false
		incense_label.visible=false
	else:
		incense.visible=true
		incense_label.visible=true
	for x in prods:
		x.visible=false
	for x in building.production_slots:
		prods[x].visible=true
		var options:Array[String] = building.get_production_options()
		prods[x].create(building,x,options)
	
	if building.ceremonies[0]!=null:
		ritual_1.text=building.ceremonies[0].name
	else:
		ritual_1.text="Perform Ceremony"
	
	if building.ceremonies[0]!=null:
		ritual_2.text=building.ceremonies[1].name
	else:
		ritual_2.text="Perform Ceremony"
	
	GM.menus.switch_side_top(self)
	
func _update_menu():
	update_menu(building)

func _on_button_pressed() -> void:
	GM.menus.ceremony_screen.update_menu(building.district.territory.stockpile,building.district.territory.population,0,building)


func _on_fuel_open(b:SelectorButton) -> void:
	var i = building.district.territory.stockpile.get_of_quality(Stuff.QUALITIES.Fuel)
	var stuff:Array[Stuff] 
	for x in i.keys():
		stuff.append(x)
	GM.menus.stuff_selector_screen.update_menu(stuff)
	var choice = await GM.menus.send_data
	if choice is Stuff:
		building.fuel=choice
	GM.menus.switch_side_bottom(GM.menus.previous_side_bottom)
	GM.menus.update_menus()


func _on_fuel_removing() -> void:
	building.fuel=null
	fuel.create(null)
	GM.menus.update_menus()


func _on_incense_open(b:SelectorButton) -> void:
	GM.menus.send_data.emit(null)
	var i = building.district.territory.stockpile.get_of_quality(Stuff.QUALITIES.Incense)
	var stuff:Array[Stuff] 
	for x in i.keys():
		stuff.append(x)
	GM.menus.stuff_selector_screen.update_menu(stuff)
	var choice = await GM.menus.send_data
	if choice is Stuff:
		building.incense=choice
	GM.menus.switch_side_bottom(GM.menus.districts_view)
	GM.menus.update_menus()


func _on_incense_removing(b:SelectorButton) -> void:
	building.incense=null
	incense.create(null)
	GM.menus.update_menus()

func _on_music_open(b:SelectorButton) -> void:
	var i = building.district.territory.stockpile.get_of_quality(Stuff.QUALITIES.Instrument)
	var stuff:Array[Stuff] 
	for x in i.keys():
		stuff.append(x)
	GM.menus.stuff_selector_screen.update_menu(stuff)
	var choice = await GM.menus.send_data
	if choice is Stuff:
		building.music=choice
	GM.menus.switch_side_bottom(GM.menus.previous_side_bottom)
	GM.menus.update_menus()

func _on_music_clicked(b:SelectorButton) -> void:
	var i = building.district.territory.stockpile.get_of_quality(Stuff.QUALITIES.Instrument)
	var stuff:Array[Stuff] 
	for x in i.keys():
		stuff.append(x)
	GM.menus.stuff_selector_screen.update_menu(stuff)
	var choice = await GM.menus.send_data
	if choice is Stuff:
		building.music=choice
	GM.menus.switch_side_bottom(GM.menus.previous_side_bottom)
	GM.menus.update_menus()

func _on_music_removing(b:SelectorButton) -> void:
	building.music=null
	music.create(null)
	GM.menus.update_menus()


func _on_dedication_open() -> void:
	if building.dedicated_lesser and building.level<3:
		return
	if building.dedication and building.dedication_ceremony:
		return
	GM.menus.dedication_selection_window.update_menu(building.district.territory)
	var choice = await GM.menus.send_data
	if choice!=null:
		if choice is Person:
			dedication.create(choice)
			building.set_dedication(choice)
		elif choice is int:
			building.lesser_dedication(choice)
			dedication.create(choice)
	GM.menus.switch_side_bottom(GM.menus.previous_side_bottom)


func _on_ritual_1_pressed() -> void:
	GM.menus.ceremony_screen.update_menu(building.storeroom,building.district.territory.population,0,building)


func _on_ritual_2_pressed() -> void:
	GM.menus.ceremony_screen.update_menu(building.storeroom,building.district.territory.population,0,building)
