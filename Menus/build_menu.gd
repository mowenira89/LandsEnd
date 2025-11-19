class_name BuildMenu extends ColorRect
@onready var grid: GridContainer = $MarginContainer/VBoxContainer/HBoxContainer/ScrollContainer/PotentialBuildingsHolder
@onready var building_title: Label = $MarginContainer/VBoxContainer/HBoxContainer/VBoxContainer/BuildingTitle
@onready var info: RichTextLabel = $MarginContainer/VBoxContainer/HBoxContainer/VBoxContainer/Info

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
		if !x.upgrade_only:
			var proceed=true
			for c in x.construction_conditions:
				if !c.check(d,d.territory,x):
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
				new_button.mouse_entered.connect(func(nb=new_button):receive_info.call(nb))
				new_button.pressed.connect(func(nb=new_button):build.call(nb))	
	GM.menus.switch_side_top(self)
	
func receive_info(b:TextureButton):
	var building = buildings[grid.get_children().find(b)]
	building_title.text=building.name
	
	var i = building.desc+"\n"
	
	i ="\n"+str(building.construction_time)+" turns to build\n\n"
	
	for x in building.construction_materials:
		i+=x.name+": "+str(building.construction_materials[x])+"\n"
	
	
	info.text=i		
	currently_selected=building
	
	
func build(t:TextureButton):
	var building = buildings[grid.get_children().find(t)]
	var new_event=BuildEvent.new()
	new_event.make_plans(building,district,stockpile)
	if stockpile.owner is Unit and stockpile.owner.add_event(new_event,district,building):
		GM.menus.switch_side_top(GM.menus.previous_side_top)
		GM.menus.update_menus()
	elif GM.add_event(new_event,district,building):
		GM.menus.switch_side_top(GM.menus.previous_side_top)
		GM.menus.update_menus()
		
			
func _update_menu():
	update_menu(district,stockpile)
