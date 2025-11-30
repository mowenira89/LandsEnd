class_name BattleStateActionSelect extends BattleState
@onready var action_container: HBoxContainer = $"../../MarginContainer/MarginContainer/ActionContainer"
@onready var melee: Button = $"../../MarginContainer/MarginContainer/ActionContainer/Melee"
@onready var missile: Button = $"../../MarginContainer/MarginContainer/ActionContainer/Missile"
@onready var fortify: Button = $"../../MarginContainer/MarginContainer/ActionContainer/Fortify"
@onready var magic: Button = $"../../MarginContainer/MarginContainer/ActionContainer/Magic"
@onready var item: Button = $"../../MarginContainer/MarginContainer/ActionContainer/Item"
@onready var cancel: Button = $"../../MarginContainer/MarginContainer/ActionContainer/Cancel"
@onready var retreat_container: HBoxContainer = $"../../MarginContainer/MarginContainer/RetreatContainer"

func get_state_name()->String:
	return "Action"

func enter():
	retreat_container.visible=false
	action_container.visible=true
	missile.visible=false
	var weapon = state_machine.selected_fighter.inventory.weapon
	if weapon and weapon is Weapon:
		if weapon.damage_type==Weapon.DAMAGE_TYPE.Missile:
			missile.visible=true
	magic.visible=false
	if !state_machine.selected_fighter.known_spells.is_empty():
		magic.visible=true
		
	for x in state_machine.allies:
		x.targeted.connect(targeted)
		x.enable()
		x.open.connect(move)
		
	for x in state_machine.enemies:
		x.targeted.connect(targeted)
		x.disable()
		
		
func move(p:PersonSelectorButton):
	var new = MoveBattleEvent.new()
	new.make_plans(state_machine.selected_fighter,p)
		
func handle_input(event:InputEvent):
	if event.is_action_released("Right Click"):
		GM.send_data.emit(null)
		
func missile_clicked():
	for x in state_machine.enemies:
		x.target()
	var choice = await GM.menus.send_data
	if choice:
		var new = BattleEventMissile.new()
		new.make_plans(state_machine.selected_fighter,choice)
		var place:PersonSelectorButton = state_machine.get_fighter_place(state_machine.selected_fighter)
		place.ordered()
		state_machine.orders[state_machine.selected_fighter]=new
	for x in state_machine.enemies:
		x.untarget()
		
func melee_clicked():
	for x in state_machine.enemies:
		if x.person:
			x.target()
	var choice = await GM.menus.send_data
	if choice:
		var new = MeleeBattleEvent.new()
		new.make_plans(state_machine.selected_fighter,choice.person)
		var place:PersonSelectorButton = state_machine.get_fighter_place(state_machine.selected_fighter)
		place.ordered()
		state_machine.orders[state_machine.selected_fighter]=new
		state_finished.emit("CharacterSelect")
	for x in state_machine.enemies:
		if x.person:
			x.untarget()


func targeted(p:PersonSelectorButton):
	GM.menus.send_data.emit(p)

func _on_missile_pressed() -> void:
	pass # Replace with function body.


func _on_melee_pressed() -> void:
	melee_clicked()
