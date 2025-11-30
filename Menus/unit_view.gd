class_name UnitView extends MarginContainer

var unit:Unit

@onready var leader: PersonSelectorButton = $ColorRect/MarginContainer/VBoxContainer/HBoxContainer2/VBoxContainer/HBoxContainer/VBoxContainer/PersonSelectorButton

@onready var leader_name: Label = $ColorRect/MarginContainer/VBoxContainer/HBoxContainer2/VBoxContainer/HBoxContainer/VBoxContainer/LeaderName
@onready var leader_title: Label = $ColorRect/MarginContainer/VBoxContainer/HBoxContainer2/VBoxContainer/HBoxContainer/VBoxContainer/LeaderTitle
@onready var outfit_holder: HBoxContainer = $ColorRect/MarginContainer/VBoxContainer/HBoxContainer2/VBoxContainer/HBoxContainer/VBoxContainer4/OutfitHolder
@onready var companions_container: HBoxContainer = $ColorRect/MarginContainer/VBoxContainer/HBoxContainer2/VBoxContainer/HBoxContainer/VBoxContainer4/CompanionsContainer
@onready var guards_container: HBoxContainer = $ColorRect/MarginContainer/VBoxContainer/HBoxContainer2/VBoxContainer/HBoxContainer/VBoxContainer4/GuardsContainer
@onready var follower: Label = $ColorRect/MarginContainer/VBoxContainer/HBoxContainer3/Follower
@onready var monks: Label = $ColorRect/MarginContainer/VBoxContainer/HBoxContainer3/Monks
@onready var soldiers: Label = $ColorRect/MarginContainer/VBoxContainer/HBoxContainer3/Soldiers
@onready var artists: Label = $ColorRect/MarginContainer/VBoxContainer/HBoxContainer3/Artists
@onready var cargo_grid: GridContainer = $ColorRect/MarginContainer/VBoxContainer/ScrollContainer/CenterContainer/CargoGrid
@onready var event_container: VBoxContainer = $ColorRect/MarginContainer/VBoxContainer/HBoxContainer2/HBoxContainer/VBoxContainer/ScrollContainer/EventContainer

const EVENT_BUTTON = "uid://muftl1jdfcjj"


var toggled_buttons:Array[Button] = []

const PERSON_SELECTOR = preload("res://Menus/PersonSelectButton.tscn")

func update_menu(u:Unit):
	unit=u
	var followers = unit.followers.get_pop_breakdown()
	follower.text = "Followers: "+str(followers[Pop.CLASS.Follower])
	soldiers.text = "Soldiers: "+str(followers[Pop.CLASS.Soldier])
	monks.text = "Monks: "+str(followers[Pop.CLASS.Monk])
	artists.text = "Artists: "+str(followers[Pop.CLASS.Artist])
	leader.reset()
	leader.create(unit.leader)
	leader_name.text=unit.leader.name
	leader_title.text=unit.leader.title
	
	for x in companions_container.get_children():
		x.queue_free()
	for x in guards_container.get_children():
		x.queue_free()
	for x in cargo_grid.get_children():
		x.queue_free()
	for x in unit.cargo.outfit.size():
		if unit.cargo.outfit[x]:
			outfit_holder.get_child(x).text=unit.cargo.outfit[x].name
		else:
			outfit_holder.get_child(x).text="---"
#		label.pressed.connect(func(nb=label):open_outfit.call(nb))
	for x in unit.companions:
		var b = PERSON_SELECTOR.instantiate()
		companions_container.add_child(b)
		b.create(x)
	for x in unit.cargo.stuff:
		var label = Label.new()
		cargo_grid.add_child(label)
		var num = int(unit.cargo.stuff[x])
		label.text=str(num)+" "+x.name+". "
	
	
	for x in event_container.get_children():
		x.queue_free()
	for x in unit.action_queue:
		var pre = load(EVENT_BUTTON)
		var label = pre.instantiate()
		event_container.add_child(label)
		label.create(x,unit)
		
	GM.menus.switch_side_top(self)
	
	
func _update_menu():
	update_menu(unit)

func get_outfit_menu(index:int):
	GM.menus.send_data.emit(null)
	var items:Array[Stuff]=unit.cargo.get_outfit()
	GM.menus.stuff_selector_screen.update_menu(items)
	var new_outfit = await GM.menus.send_data
	if new_outfit:
		var stuff = RM.stuff[new_outfit]
		if unit.cargo.outfit[index]:
			unit.cargo.add_max(unit.outfit[index],1)
		unit.cargo.remove_stuff(stuff,1)
		unit.cargo.outfit[index]=stuff
	GM.menus.update_menus()


func _on_outfit_1_pressed() -> void:
	get_outfit_menu(0)

func _on_outfit_2_pressed() -> void:
	get_outfit_menu(1)

func _on_outfit_3_pressed() -> void:
	get_outfit_menu(2)

func _on_outfit_4_pressed() -> void:
	get_outfit_menu(3)
