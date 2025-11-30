class_name CropSelectScreen extends Control

var building:Farm
@onready var crops_label: Label = $MarginContainer/VBoxContainer/CropsLabel
@onready var crops: GridContainer = $MarginContainer/VBoxContainer/Crops
@onready var livestock_label: Label = $MarginContainer/VBoxContainer/LivestockLabel
@onready var livestock: GridContainer = $MarginContainer/VBoxContainer/Livestock

func _update_menu():
	update_menu(building)

func update_menu(b:Farm):
	building=b
	crops_label.visible=false
	for x in crops.get_children():
		x.queue_free()
	livestock_label.visible=false
	for x in livestock.get_children():
		x.queue_free()
	if b.raise_crops:
		crops_label.visible=true
		for x in GM.unlocked_crops:
			if x.crop_level<=1+(float(building.level)/3):
				var button = Button.new()
				crops.add_child(button)
				button.text=x.name
				button.pressed.connect(receive_text.bind(x.name))
	if b.raise_livestock:
		livestock_label.visible=true
		for x in building.district.territory.stockpile.animal_order:
			var button = Button.new()
			livestock.add_child(button)
			button.text=x.name
			button.pressed.connect(receive_text.bind(x.name))
	GM.menus.switch_side_bottom(self)
	
func receive_text(t:String):
	var c
	if t in RM.species.keys():
		c=RM.species[t]
	else:
		c=RM.stuff[t]
	GM.menus.send_data.emit(c)
	GM.menus.switch_side_bottom(GM.menus.districts_view)
