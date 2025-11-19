class_name UnitView extends MarginContainer

var unit:Unit

@onready var follower: Label = $ColorRect/MarginContainer/HBoxContainer2/VBoxContainer/HBoxContainer2/Follower
@onready var monks: Label = $ColorRect/MarginContainer/HBoxContainer2/VBoxContainer/HBoxContainer2/Monks
@onready var soldiers: Label = $ColorRect/MarginContainer/HBoxContainer2/VBoxContainer/HBoxContainer2/Soldiers
@onready var artists: Label = $ColorRect/MarginContainer/HBoxContainer2/VBoxContainer/HBoxContainer2/Artists
@onready var leader_name: Label = $ColorRect/MarginContainer/HBoxContainer2/VBoxContainer/HBoxContainer/VBoxContainer/LeaderName
@onready var leader_title: Label = $ColorRect/MarginContainer/HBoxContainer2/VBoxContainer/HBoxContainer/VBoxContainer/LeaderTitle
@onready var leader: PersonSelectorButton = $ColorRect/MarginContainer/HBoxContainer2/VBoxContainer/HBoxContainer/VBoxContainer/PersonSelectorButton
@onready var outfit_container: HBoxContainer = $ColorRect/MarginContainer/HBoxContainer2/VBoxContainer/HBoxContainer/VBoxContainer3/OutfitContainer
@onready var companions_container: HBoxContainer = $ColorRect/MarginContainer/HBoxContainer2/VBoxContainer/HBoxContainer/VBoxContainer3/CompanionsContainer
@onready var guards_container: HBoxContainer = $ColorRect/MarginContainer/HBoxContainer2/VBoxContainer/HBoxContainer/VBoxContainer3/GuardsContainer
@onready var cargo_grid: GridContainer = $ColorRect/MarginContainer/HBoxContainer2/VBoxContainer/ScrollContainer/CenterContainer/CargoGrid
@onready var event_container: VBoxContainer = $ColorRect/MarginContainer/HBoxContainer2/HBoxContainer/VBoxContainer/ScrollContainer/EventContainer

const EVENT_BUTTON=preload("res://Menus/event_button.tscn")

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
	
	for x in outfit_container.get_children():
		x.queue_free()
	for x in companions_container.get_children():
		x.queue_free()
	for x in guards_container.get_children():
		x.queue_free()
	for x in cargo_grid.get_children():
		x.queue_free()
	for x in unit.outfit.stuff:
		var label = Label.new()
		outfit_container.add_child(label)
		label.text=x.name
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
		var label = EVENT_BUTTON.instantiate()
		event_container.add_child(label)
		label.create(x,unit)
		
	GM.menus.switch_side_top(self)
	
	
func _update_menu():
	update_menu(unit)
