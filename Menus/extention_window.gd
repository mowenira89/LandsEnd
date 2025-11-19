class_name ExtentionWindow extends Control
@onready var grid: GridContainer = $MarginContainer/ColorRect/MarginContainer/HBoxContainer/Grid
@onready var label: Label = $MarginContainer/ColorRect/MarginContainer/HBoxContainer/VBoxContainer/Label
@onready var info: RichTextLabel = $MarginContainer/ColorRect/MarginContainer/HBoxContainer/VBoxContainer/Info

var building:Building
var extentions=[]

func _update_menu():
	update_menu(building)
	
	
func update_menu(b:Building):
	building=b
	extentions.clear()
	for x in grid.get_children():
		x.queue_free()
	for x in building.possible_extentions:
		if x in GM.unlocked_buildings:
			extentions.append(x)
			var new = TextureButton.new()
			new.texture_normal=x.image
			new.pressed.connect(func(nb=new):build.call(nb))
			
func build(b:TextureButton):
	var index = grid.get_children().find(b)
	var ext = extentions[index]
	var new = BuildExtentionEvent.new()
	new.make_plans(building,building.district.territory.stockpile,ext,index)
	
	
