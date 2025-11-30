class_name CeremonyScreen extends Control

var stockpile:Stockpile
var population:Population
var building:Temple
var unit:Unit


@onready var priest: PersonSelectorButton = $MarginContainer/HBoxContainer/VBoxContainer4/Priest
@onready var incense: SelectorButton = $MarginContainer/HBoxContainer/VBoxContainer/Incense
@onready var fuel: SelectorButton = $MarginContainer/HBoxContainer/VBoxContainer/Fuel
@onready var offering: SelectorButton = $MarginContainer/HBoxContainer/VBoxContainer2/Offering
@onready var ceremony: Button = $MarginContainer/HBoxContainer/VBoxContainer2/Ceremony
@onready var music: SelectorButton = $MarginContainer/HBoxContainer/VBoxContainer3/Music
@onready var libation: SelectorButton = $MarginContainer/HBoxContainer/VBoxContainer3/Libation
@onready var target: DedicationSelectorButton = $MarginContainer/HBoxContainer/VBoxContainer5/Target
@onready var button: Button = $MarginContainer/Button


@onready var buttons = {
	Stuff.QUALITIES.Incense:incense,
	Stuff.QUALITIES.Fuel:fuel,
	Stuff.QUALITIES.Instrument:music,
	Stuff.QUALITIES.Libation:libation,
	"target":target,
	"priest":priest,
	"offering":offering,
}

var potential_ceremony:Ceremony

var potential_provisions = {}

func get_fresh_dict():
	var r = {
		Stuff.QUALITIES.Incense:null,
		Stuff.QUALITIES.Fuel:null,
		Stuff.QUALITIES.Instrument:null,
		Stuff.QUALITIES.Libation:null,
		"target":null,
		"priest":null,
		"offering":null
	}
	return r

var ongoing_ceremony:Ceremony

@onready var info_container: VBoxContainer = $MarginContainer/InfoContainer

var building_index=-1

func _update_menu():
	update_menu(stockpile,population,building_index,building,unit,ongoing_ceremony)


func update_menu(s:Stockpile,p:Population,bi:int,b:Temple=null,u:Unit=null,oc:Ceremony=null):
	stockpile=s
	population=p
	building=b
	unit=u
	ongoing_ceremony=oc
	building_index=bi
	

	if GM.menus.previous_side_bottom==GM.menus.districts_view or GM.menus.previous_side_bottom==GM.menus.pop_bottom_menu:
		potential_provisions=get_fresh_dict()
		potential_ceremony=null
	
	if ongoing_ceremony:
		potential_provisions=ongoing_ceremony.provisions
		button.text="Ceremony Ongoing"
		button.disabled=true
	else:
		button.text="Commit to Ceremony"
		button.disabled=false
	
	for x in potential_provisions:
		if x!="offering":
			buttons[x].create(potential_provisions[x])
		else:
			buttons[x].create(potential_provisions[x][0])
	
	if building:
		if building.dedicated_lesser:
			target._disabled=true
		elif building.dedication:
			target._disabled=true
		else:
			target._disabled=false
	if unit:
		target._disabled=false
	
	GM.menus.switch_side_bottom(self)



func _on_fuel_open(b:SelectorButton) -> void:
	if !ongoing_ceremony:
		var stuff:Array[Stuff] = []
		for x in stockpile.get_of_quality(Stuff.QUALITIES.Fuel).keys():
			stuff.append(x)
		GM.menus.stuff_selector_screen.update_menu(stuff)
		var choice = await GM.menus.send_data
		if choice:
			fuel.create(RM.stuff[choice])
			potential_provisions[Stuff.QUALITIES.Fuel]=choice
		GM.menus.switch_side_bottom(GM.menus.ceremony_screen)

func _on_ceremony_pressed() -> void:
	GM.menus.ceremony_selection_sceen.update_menu(building,unit)
	var choice = await GM.menus.send_data
	if choice:
		potential_ceremony=MagicManager.ceremonies[choice]
		ceremony.text=choice
	GM.menus.switch_side_bottom(self)


func _on_fuel_removing(b:SelectorButton) -> void:
	if !ongoing_ceremony:
		potential_provisions[Stuff.QUALITIES.Fuel]=null
		_update_menu()


func _on_incense_open(b:SelectorButton) -> void:
	if !ongoing_ceremony:
		var stuff:Array[Stuff] = []
		for x in stockpile.get_of_quality(Stuff.QUALITIES.Incense).keys():
			stuff.append(x)
		GM.menus.stuff_selector_screen.update_menu(stuff)
		var choice = await GM.menus.send_data
		if choice:
			incense.create(RM.stuff[choice])
			potential_provisions[Stuff.QUALITIES.Incense]=choice
		GM.menus.switch_side_bottom(self)


func _on_incense_removing(b:SelectorButton) -> void:
	if !ongoing_ceremony:
		potential_provisions[Stuff.QUALITIES.Incense]=null
		_update_menu()


func _on_offering_open(b:SelectorButton) -> void:
	if !ongoing_ceremony:
		GM.menus.item_amount_selector.update_menu(building.district.territory.stockpile)
		var choice = await GM.menus.item_amount_selector.get_stuff_and_amount
		if choice:
			offering.create(choice[0])
			potential_provisions["offering"]=choice
		GM.menus.switch_side_bottom(self)
		GM.menus.update_menus()

func _on_offering_removing(b:SelectorButton) -> void:
	if !ongoing_ceremony:
		offering.create(null)
		potential_provisions['offering']=null


func _on_libation_open() -> void:
	if !ongoing_ceremony:
		var stuff:Array[Stuff]=[]
		for x in stockpile.get_of_quality(Stuff.QUALITIES.Libation):
			stuff.append(x)
		GM.menus.stuff_selector_screen.update_menu(stuff)
		var choice = await GM.menus.send_data
		if choice:
			var c = RM.stuff[choice]
			libation.create(c)
			potential_provisions[Stuff.QUALITIES.Libation]=c
		GM.menus.switch_side_bottom(self)
		GM.menus.update_menus()



func _on_libation_removing() -> void:
	if !ongoing_ceremony:
		libation.create(null)
		potential_provisions[Stuff.QUALITIES.Libation]=null


func _on_button_pressed() -> void:
	if potential_ceremony!=null:
		var ceremony = potential_ceremony.duplicate()


func _on_target_open() -> void:
	if !ongoing_ceremony:
		GM.menus.dedication_select_window.update_menu(building,unit)
		var choice = await GM.menus.send_data
		if choice:
			potential_provisions['target']=choice
			_update_menu()
		GM.menus.switch_side_bottom(self)

func _on_target_removing() -> void:
	potential_provisions['target']=null
	_update_menu()


func _on_x_button_pressed() -> void:
	pass # Replace with function body.
