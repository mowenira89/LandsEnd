class_name BuildMenu extends ColorRect
@onready var grid: GridContainer = $MarginContainer/VBoxContainer/HBoxContainer/PotentialBuildingsHolder
@onready var building_title: Label = $MarginContainer/VBoxContainer/HBoxContainer/VBoxContainer/BuildingTitle
@onready var pic: TextureRect = $MarginContainer/VBoxContainer/HBoxContainer/VBoxContainer/Pic
@onready var info: RichTextLabel = $MarginContainer/VBoxContainer/HBoxContainer/VBoxContainer/Info

var district:District

const BUILDTHISBUTTON = preload("res://Menus/build_this_button.tscn")

var buildings:Array[Building]

func update_menu(d:District):
	district=d
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
			var new_button = BUILDTHISBUTTON.instantiate()
			grid.add_child(new_button)
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
	for x in building.construction_staff:
		i+=Pop.CLASS.keys()[x]+": "+str(building.construction_staff[x])+". "
	i+="Turns: "+str(building.construction_time)
	info.text=i		
	
	
	
	
	
func _update_menu():
	update_menu(district)


func _on_build_pressed() -> void:
	pass # Replace with function body.
