class_name BattleStateCharacterSelect extends BattleState

@onready var attack: Button = $"../../MarginContainer/MarginContainer/RetreatContainer/Attack"
@onready var start_battle: Button = $"../../MarginContainer/MarginContainer/VBoxContainer2/StartBattle"
@onready var retreat_container: HBoxContainer = $"../../MarginContainer/MarginContainer/RetreatContainer"
@onready var action_container: HBoxContainer = $"../../MarginContainer/MarginContainer/ActionContainer"



func get_state_name()->String:
	return "CharacterSelect"

func enter():
	for x in state_machine.allies:
		x.disable()
		x.clicked.connect(select_character)
		x.battle_order_revoked.connect(revoke_order)
	start_battle.visible=false
	attack.disabled=state_machine.orders.is_empty()
	action_container.visible=false
	retreat_container.visible=true
		
func select_character(p:PersonSelectorButton):
	state_machine.selected_fighter=p.person
	state_finished.emit("Action")
	
func revoke_order(p:PersonSelectorButton):
	p.order_revoked()
	state_machine.orders.erase(p.person)
	attack.disabled=state_machine.orders.is_empty()
	
	
func exit():
	for x in state_machine.allies:
		x.clicked.disconnect(select_character)
		x.battle_order_revoked.disconnect(revoke_order)

func _on_attack_pressed() -> void:
	state_finished.emit("Resolve")
