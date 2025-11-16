class_name BuildMenu extends ColorRect
@onready var grid: GridContainer = $MarginContainer/VBoxContainer/HBoxContainer/PotentialBuildingsHolder
@onready var building_title: Label = $MarginContainer/VBoxContainer/HBoxContainer/VBoxContainer/BuildingTitle
@onready var pic: TextureRect = $MarginContainer/VBoxContainer/HBoxContainer/VBoxContainer/Pic
@onready var info: RichTextLabel = $MarginContainer/VBoxContainer/HBoxContainer/VBoxContainer/Info
@onready var build: Button = $MarginContainer/Build

var district:District

var buildings:Array[Building]
var stockpile:Stockpile

var currently_selected

func update_menu(d:District,s:Stockpile):
	district=d
	stockpile=s
	currently_selected=null
	for x in grid.get_children():
		x.queue_free()
	buildings.clear()
	for x in GM.unlocked_buildings:
		var proceed=true
		for c in x.construction_conditions:
			if !c.check(d):
				proceed=false
				break
		if proceed:
			var new_button = TextureButton.new()
			grid.add_child(new_button)
			new_button.ignore_texture_size=true
			new_button.stretch_mode=TextureButton.STRETCH_SCALE
			new_button.custom_minimum_size=Vector2(75,75)
			buildings.append(x)
			new_button.texture_normal=x.image
			new_button.pressed.connect(func(nb=new_button):receive_info.call(nb))
	
	GM.menus.switch_side_top(self)
	
func receive_info(b:TextureButton):
	var building = buildings[grid.get_children().find(b)]
	pic.texture=building.image
	building_title.text=building.name
	var i="Construction:\n"
	for x in building.construction_materials:
		i+=x.name+": "+str(building.construction_materials[x])+". "
	
	i+="\nTurns: "+str(building.construction_time)
	info.text=i		
	currently_selected=building
	
	
	
	
func _update_menu():
	update_menu(district,stockpile)


func _on_build_pressed() -> void:
	if currently_selected:
		var new_event=Event.new()
		new_event.create("build_in"+district.territory.name+str(district.index),"Building",currently_selected.construction_time)
		var effect = BuildEffect.new()
		effect.create(currently_selected,district,stockpile)
		new_event.effects.append(effect)
		if GM.add_event(new_event):
			GM.menus.switch_side_top(GM.menus.previous_side_top)
			GM.menus.update_menus()
