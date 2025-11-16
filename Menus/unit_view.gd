class_name UnitView extends MarginContainer

var unit:Unit
@onready var follower: Label = $ColorRect/MarginContainer/VBoxContainer/HBoxContainer2/Follower
@onready var monks: Label = $ColorRect/MarginContainer/VBoxContainer/HBoxContainer2/Monks
@onready var soldiers: Label = $ColorRect/MarginContainer/VBoxContainer/HBoxContainer2/Soldiers
@onready var artists: Label = $ColorRect/MarginContainer/VBoxContainer/HBoxContainer2/Artists
@onready var leader_name: Label = $ColorRect/MarginContainer/VBoxContainer/HBoxContainer/VBoxContainer/LeaderName
@onready var leader_title: Label = $ColorRect/MarginContainer/VBoxContainer/HBoxContainer/VBoxContainer/LeaderTitle
@onready var leader: PersonSelectorButton = $ColorRect/MarginContainer/VBoxContainer/HBoxContainer/VBoxContainer/PersonSelectorButton
@onready var outfit_container: HBoxContainer = $ColorRect/MarginContainer/VBoxContainer/HBoxContainer/VBoxContainer3/OutfitContainer
@onready var companions_container: HBoxContainer = $ColorRect/MarginContainer/VBoxContainer/HBoxContainer/VBoxContainer3/CompanionsContainer
@onready var guards_container: HBoxContainer = $ColorRect/MarginContainer/VBoxContainer/HBoxContainer/VBoxContainer3/GuardsContainer
@onready var cargo_grid: GridContainer = $ColorRect/MarginContainer/VBoxContainer/ScrollContainer/CenterContainer/CargoGrid


@onready var move_button: Button = $ColorRect/MarginContainer/HBoxContainer/VBoxContainer/HBoxContainer/VBoxContainer3/MoveButton
@onready var attack_button: Button = $ColorRect/MarginContainer/HBoxContainer/VBoxContainer/HBoxContainer/VBoxContainer3/AttackButton
@onready var fortify: Button = $ColorRect/MarginContainer/HBoxContainer/VBoxContainer/HBoxContainer/VBoxContainer3/Fortify
@onready var plunder: Button = $ColorRect/MarginContainer/HBoxContainer/VBoxContainer/HBoxContainer/VBoxContainer3/Plunder
@onready var assimilate: Button = $ColorRect/MarginContainer/HBoxContainer/VBoxContainer/HBoxContainer/VBoxContainer3/Assimilate
@onready var survey_button: Button = $ColorRect/MarginContainer/HBoxContainer/VBoxContainer/HBoxContainer/VBoxContainer2/SurveyButton
@onready var trade_button: Button = $ColorRect/MarginContainer/HBoxContainer/VBoxContainer/HBoxContainer/VBoxContainer2/TradeButton
@onready var commune_button: Button = $ColorRect/MarginContainer/HBoxContainer/VBoxContainer/HBoxContainer/VBoxContainer2/CommuneButton
@onready var build_button: Button = $ColorRect/MarginContainer/HBoxContainer/VBoxContainer/HBoxContainer/VBoxContainer2/BuildButton
@onready var disband_button: Button = $ColorRect/MarginContainer/HBoxContainer/VBoxContainer/HBoxContainer/VBoxContainer2/DisbandButton
@onready var split_button: Button = $ColorRect/MarginContainer/HBoxContainer/VBoxContainer/SplitButton
@onready var event_container: VBoxContainer = $ColorRect/MarginContainer/HBoxContainer/VBoxContainer/ScrollContainer/EventContainer

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
	leader.create(null,unit.leader)
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
		b.create(null,x)
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
	




	
