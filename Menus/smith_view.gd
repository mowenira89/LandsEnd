class_name SmithView extends BasicBuildingView

@onready var fuel: SelectorButton = $MarginContainer/HBoxContainer/VBoxContainer/HBoxContainer/ProductionContainers/VBoxContainer/Fuel


func update_menu(b:Building):
	super(b)
	fuel.create(building.fuel)

func _on_selector_button_open(b:SelectorButton) -> void:
	var stuff:Array[Stuff]=[]
	var fuel = building.district.territory.stockpile.get_of_quality(Stuff.QUALITIES.Fuel)
	for x in fuel:
		stuff.append(x)
	GM.menus.stuff_selector_screen.update_menu(stuff)
	var choice = await GM.menus.send_data
	if choice is Stuff:
		building.fuel=stuff
	GM.menus.switch_side_bottom(GM.menus.previous_side_bottom)
	GM.menus.update_menus()

func _on_selector_button_removing(b:SelectorButton) -> void:
	building.fuel=null
	fuel.create(null)
