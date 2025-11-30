class_name CropStatView extends Control

var crop
var building:Building
@onready var vbox: VBoxContainer = $container1/vbox
@onready var selector_button: SelectorButton = $container1/VBoxContainer/SelectorButton


func update_menu(s,b:Building):
	crop=s
	building=b
	for x in vbox.get_children():
		x.queue_free()
	var name_label = Label.new()
	vbox.add_child(name_label)
	
	name_label.text=crop.name
	var health_label = Label.new()
	vbox.add_child(health_label)
	health_label.text="Health: "+str(crop.current_health)+"/"+str(crop.health)
	if crop is Crop:
		var growth_label = Label.new()
		vbox.add_child(growth_label)
		growth_label.text = "Current Growth: "+str(crop.growth)
		if crop.starting_up>0:
			growth_label.text+="\nStarting Up: "+str(crop.starting_up)
		growth_label.text+="\nHarvest Months: "
		for x in crop.harvest_season:
			growth_label.text+=GM.MONTHS.keys()[x]+" "
	elif crop is Herd:
		var indv_label = Label.new()
		vbox.add_child(indv_label)
		indv_label.text=str(crop.individuals)+" individuals"
		indv_label.text+="\nHealth: "+str(crop.stats.current_hp)+"/"+str(crop.stats.total_hp)
		var harvest = Label.new()
		vbox.add_child(harvest)
		harvest.text="Harvest months: "
		for x in crop.species.harvest_season:
			harvest.text+=GM.MONTHS.keys()[x]+" "
	GM.menus.switch_side_bottom(self)

func _update_menu():
	update_menu(crop,building)


func _on_selector_button_open(b:SelectorButton) -> void:
	GM.menus.feed_select_screen.update_menu(crop,building.district.territory.stockpile)
	var feed = await GM.menus.send_data
	if feed is Stuff:
		crop.food=feed
	GM.menus.switch_side_bottom(GM.menus.crop_stat_view)
	GM.menus.update_menus()

func _on_selector_button_clicked(b:SelectorButton) -> void:
	GM.menus.feed_select_screen.update_menu(crop,building.district.territory.stockpile)
	var food = await GM.menus.send_data
	if food is Stuff:
		crop.food=food
		_update_menu()

func _on_selector_button_removing(b:SelectorButton) -> void:
	crop.food=null
	_update_menu()
