class_name BasicBuildingView extends ColorRect

var building:Building
@onready var production_containers: VBoxContainer = $MarginContainer/VBoxContainer/HBoxContainer/ProductionContainers
@onready var leader: VBoxContainer = $MarginContainer/VBoxContainer/HBoxContainer/Leader
@onready var extentions: VBoxContainer = $MarginContainer/VBoxContainer/HBoxContainer/Extentions
@onready var label_2: Label = $MarginContainer/VBoxContainer/Label2
@onready var label: Label = $MarginContainer/VBoxContainer/Label

const PRODUCTION_SLOT = preload("res://Menus/production_container.tscn")

func _ready():
	call_deferred("connect_signal")

func connect_signal():
	GM.menus.recipe_menu.emit_name.connect(receive_production_data)

func update_menu(b:Building):
	building = b
	
	var s = building.district.territory.name+" District "+str(building.district.index)+" "+building.name
	label.text=s
	label_2.text = District.TYPES.keys()[building.district.type]
	
	for x in production_containers.get_children():
		x.queue_free()
	for x in building.production_slots:
		var nb = PRODUCTION_SLOT.instantiate()
		production_containers.add_child(nb)
		var options:Array[String] = building.get_production_options()
		nb.create(building,x,options)
	GM.menus.switch_side_top(self)
	
func _update_menu():
	update_menu(building)

func receive_production_data(t:String,i:int):
	for x in production_containers.get_children():
		if x.index==i:
			x.title=t
