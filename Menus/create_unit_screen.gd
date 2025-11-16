class_name CreateUnitScreen extends ColorRect

@export var stockpile:Stockpile

@onready var overlay: ColorRect = $Overlay
@onready var store_container_container: MarginContainer = $Overlay/StoreContainerContainer
@onready var stuff_mover: MarginContainer = $Overlay/StuffMover
@onready var actual_stuff_mover: StuffMover = $Overlay/StuffMover/VBoxContainer/StuffMover
@onready var mover_holder: VBoxContainer = $VBoxContainer/HBoxContainer/MarginContainer/VBoxContainer/HBoxContainer2/ScrollContainer/CenterContainer/HBoxContainer/MoverHolder
@onready var leader: PersonSelectorButton = $VBoxContainer/HBoxContainer/VBoxContainer/PersonSelectorButton


@onready var outfit_1: Button = $VBoxContainer/HBoxContainer/MarginContainer/VBoxContainer/HBoxContainer5/VBoxContainer2/HBoxContainer/Outfit1
@onready var outfit_2: Button = $VBoxContainer/HBoxContainer/MarginContainer/VBoxContainer/HBoxContainer5/VBoxContainer2/HBoxContainer/Outfit2
@onready var outfit_3: Button = $VBoxContainer/HBoxContainer/MarginContainer/VBoxContainer/HBoxContainer5/VBoxContainer2/HBoxContainer/Outfit3
@onready var outfit_4: Button = $VBoxContainer/HBoxContainer/MarginContainer/VBoxContainer/HBoxContainer5/VBoxContainer2/HBoxContainer/Outfit4
@onready var followers: Button = $VBoxContainer/HBoxContainer/MarginContainer/VBoxContainer/HBoxContainer5/VBoxContainer2/HBoxContainer4/Followers
@onready var soldiers: Button = $VBoxContainer/HBoxContainer/MarginContainer/VBoxContainer/HBoxContainer5/VBoxContainer2/HBoxContainer4/Soldiers
@onready var artists: Button = $VBoxContainer/HBoxContainer/MarginContainer/VBoxContainer/HBoxContainer5/VBoxContainer2/HBoxContainer4/Artists
@onready var monks: Button = $VBoxContainer/HBoxContainer/MarginContainer/VBoxContainer/HBoxContainer5/VBoxContainer2/HBoxContainer4/Monks

@onready var companion_1: PersonSelectorButton = $VBoxContainer/HBoxContainer/MarginContainer/VBoxContainer/HBoxContainer5/VBoxContainer2/HBoxContainer3/Companion1
@onready var companion_2: PersonSelectorButton = $VBoxContainer/HBoxContainer/MarginContainer/VBoxContainer/HBoxContainer5/VBoxContainer2/HBoxContainer3/Companion2
@onready var companion_3: PersonSelectorButton = $VBoxContainer/HBoxContainer/MarginContainer/VBoxContainer/HBoxContainer5/VBoxContainer2/HBoxContainer3/Companion3
@onready var guard_1: PersonSelectorButton = $VBoxContainer/HBoxContainer/MarginContainer/VBoxContainer/HBoxContainer5/VBoxContainer2/HBoxContainer5/Guard1
@onready var guard_2: PersonSelectorButton = $VBoxContainer/HBoxContainer/MarginContainer/VBoxContainer/HBoxContainer5/VBoxContainer2/HBoxContainer5/Guard2
@onready var guard_3: PersonSelectorButton = $VBoxContainer/HBoxContainer/MarginContainer/VBoxContainer/HBoxContainer5/VBoxContainer2/HBoxContainer5/Guard3

@onready var store_container: VBoxContainer = $Overlay/StoreContainerContainer/ColorRect/ScrollContainer/StoreContainer

var territory:Territory

signal emit_stuff
signal end_stuff_mover

const STUFF_ICON = preload("res://Menus/stuff_icon.tscn")

var holding_outfit:Dictionary[Stuff,int] = {}
var holding_stuff:Dictionary[Stuff,int] = {}

func update_menu(t:Territory):
	territory=t
	
func new_party(leader:Person):
	for x in [outfit_1,outfit_2,outfit_3,outfit_4]:
		x.text="----"
	followers.text="0 Follower"
	soldiers.text="0 Soldier"
	artists.text="0 Artist"
	monks.text="0 Monk"
	for x in [companion_1,companion_2,companion_3,guard_1,guard_2,guard_3]:
		x.reset()
	for x in [followers,monks,soldiers,artists]:
		followers_to_zero(x)
	visible=true
	


func get_store(setting:String):
	for x in store_container.get_children():
		x.queue_free()
	match setting: 
		"Store":
			for x in territory.stockpile.stuff:
				var button=Button.new()
				store_container.add_child(button)
				button.text=x.name
				button.pressed.connect(func(b=button):emit_stuff.emit(b.text))
		"Outfit":
			for x in territory.stockpile.get_outfit():
				var button=Button.new()
				store_container.add_child(button)
				button.text=x.name
				button.pressed.connect(func(b=button):emit_stuff.emit(b.text))
			
func parse_text(s:String):
	var words = s.split(" ")
	var i = words.pop_at(0)
	var item = words.join(" ")
	i=int(i)
	return [i,item]

func change_button(button:Button):
	overlay.visible=true
	if button.text=="----":
		stuff_mover.visible=false
		store_container_container.visible=true
		
		if button in [outfit_1,outfit_2,outfit_3,outfit_4]:
			get_store("Outfit")
		
		var new_stuff = await emit_stuff
		button.text="1 "+new_stuff
		overlay.visible=false
	else:
		stuff_mover.visible=true
		store_container_container.visible=false
	


func change_followers(button):
	overlay.visible=true
	store_container_container.visible=false
	actual_stuff_mover.visible=true
	var stuff = parse_text(button.text)
	var CLASS = Pop.CLASS.keys().find(stuff[1])
	var x = territory.get_pop(CLASS)
	var cap = get_capacity()


func followers_to_zero(button):
	var stuff = parse_text(button.text)
	button.text="0 "+stuff[1]

func _on_ok_pressed() -> void:
	end_stuff_mover.emit(true)

func _on_cancel_pressed() -> void:
	end_stuff_mover.emit(false)




func _on_outfit_1_gui_input(event: InputEvent) -> void:
	if event.is_action_released("Click"):
		change_button(outfit_1)
	elif event.is_action_released("Right Click"):
		outfit_1.text="----"

func _on_outfit_2_gui_input(event: InputEvent) -> void:
	if event.is_action_released("Click"):
		change_button(outfit_2)
	elif event.is_action_released("Right Click"):
		outfit_2.text="----"

func _on_outfit_3_gui_input(event: InputEvent) -> void:
	if event.is_action_released("Click"):
		change_button(outfit_3)
	elif event.is_action_released("Right Click"):
		outfit_3.text="----"

func _on_outfit_4_gui_input(event: InputEvent) -> void:
	if event.is_action_released("Click"):
		change_button(outfit_4)
	elif event.is_action_released("Right Click"):
		outfit_1.text="----"

func get_capacity():
	var capacity=0
	for x in [outfit_1,outfit_2,outfit_3,outfit_4]:
		var array = parse_text(x)
		var stuff = RM.stuff[array[1]]
		if stuff.qualities.has(Stuff.QUALITIES.Capacity):
			capacity+=stuff.qualities[Stuff.QUALITIES.Capacity]
	return capacity
	
func get_speed():
	var speed=1
	for x in [outfit_1,outfit_2,outfit_3,outfit_4]:
		var array=parse_text(x)
		var stuff = RM.stuff[array[1]]
		if stuff.qualities.has(Stuff.QUALITIES.Travel):
			speed=max(speed,stuff.qualities[Stuff.QUALITIES.Travel])
	return speed


func _on_add_cargo_pressed() -> void:
	overlay.visible=true
	stuff_mover.visible=true
	store_container_container.visible=true
	get_store("Store")
	emit_stuff.connect(recieve_stuff)
	var add = await end_stuff_mover
	if !add:
		overlay.visible=false
	else:
		var stuff = RM.stuff[actual_stuff_mover.stuff.text]
		var hold_amt=int(actual_stuff_mover.party.text)
		holding_stuff[stuff]=hold_amt
		var new = STUFF_ICON.instantiate()
		mover_holder.add_child(new)
		var ha = str(hold_amt)
		new.create(ha+" "+stuff.name)
		new.remove.connect(remove_cargo)
		
func remove_cargo(button):
	var array = parse_text(button.button.text)
	holding_stuff.erase(RM.stuff[array[1]])
	button.queue_free()
		
func recieve_stuff(s):
	var stuff_name = s
	var stuff = RM.stuff[stuff_name]
	var stuff_amt =territory.stockpile.stuff[stuff]
	if stuff in holding_stuff:
		stuff_amt-=holding_stuff[stuff]
	var b_amt = 0
	if stuff in holding_stuff:
		b_amt=holding_stuff[stuff]
	var b_cap = get_capacity()

func create_unit(t:Territory):
	var new_unit = Unit.new()
	var new_followers = [followers,monks,soldiers,artists]
	var outfit_buttons = [outfit_1,outfit_2,outfit_3,outfit_4]
	var new_outfit = Stockpile.new()
	var new_cargo = Stockpile.new()
	var new_pops = Population.new()
	new_pops.create(territory)
	var l=leader.person

	for x in new_followers:
		var stuff = parse_text(x.text)
		var CLASS = Pop.CLASS.keys().find(stuff[1])
		new_pops.change_pop(CLASS,stuff[0])
		territory.population.change_pop(CLASS,-stuff[0])
		
	for x in outfit_buttons:
		var array = parse_text(x.text)
		var stuff = RM.stuff[array[1]]
		new_unit.outfit_order.append(stuff)
		new_outfit.add_stuff(stuff,array[0])
		territory.stockpile.remove_stuff(stuff,array[0])
		
	for x in mover_holder.get_children():
		var array = parse_text(x.button.text)
		var stuff = RM.stuff[array[1]]
		new_cargo.add_stuff(stuff,array[0])		
		territory.stockpile.remove_stuff(stuff,array[0])

	new_unit.create(territory,l,new_cargo,new_outfit,new_pops)
