class_name BattleStateCharacterPositioning extends BattleState

var potential_allies:Array[Person]=[]
@onready var battle_screen: BattleScreen = $"../.."

@onready var potential_container: HBoxContainer = $"../../MarginContainer/MarginContainer/VBoxContainer/PotentialContainerContainer/PotentialContainer"
@onready var potential_container_container: VBoxContainer = $"../../MarginContainer/MarginContainer/VBoxContainer/PotentialContainerContainer"
@onready var start_battle: Button = $"../../MarginContainer/MarginContainer/VBoxContainer2/StartBattle"
@onready var action_container: HBoxContainer = $"../../MarginContainer/MarginContainer/ActionContainer"
@onready var retreat_container: HBoxContainer = $"../../MarginContainer/MarginContainer/RetreatContainer"
@onready var magic_select_container: HBoxContainer = $"../../MarginContainer/MarginContainer/MagicSelectContainer"


const PERSON_SELECT = preload("res://Menus/PersonSelectButton.tscn")

var potential_foes:Array[Person]=[]

var currently_selected

func enter():
	
	action_container.visible=false
	retreat_container.visible=false
	magic_select_container.visible=false
	var unit:Unit = battle_screen.allies
	var foes:Unit = battle_screen.enemies
	if unit.leader:
		potential_allies.append(unit.leader)
	for x in unit.companions:
		if x:
			potential_allies.append(x)
	for x in unit.guard:
		if x:
			potential_allies.append(x)
	
	if foes.leader:
		potential_foes.append(foes.leader)
	
	for x in foes.guard:
		if x:
			potential_foes.append(x)
	for x in foes.companions:
		if x:
			potential_foes.append(x)
					
	for x in min(8,potential_foes.size()):
		var new_slot = state_machine.enemies.pick_random()
		while new_slot.person:
			new_slot=state_machine.enemies.pick_random()
		new_slot.create(potential_foes[x])	

	for x in state_machine.enemies:
		x.disable()
	for x in state_machine.allies:
		x.enable()
		
	for x in potential_container.get_children():
		x.queue_free()
		
	for x in potential_allies:
		var new = PERSON_SELECT.instantiate()
		potential_container.add_child(new)
		new.create(x)
		new.clicked.connect(func(y=new):select.call(y.person))
			
	potential_container_container.visible=true
		
	
	for x in state_machine.allies:
		x.clicked.connect(on_ally_slot_clicked)
		x.open.connect(on_ally_slot_open)
		x.removing.connect(remove_from_field)	
			
			
func select(p:Person):
	currently_selected=p
			
func on_ally_slot_clicked(p:PersonSelectorButton):
	#currently_selected=p.person
	pass
	
func on_ally_slot_open(x:PersonSelectorButton):
	if currently_selected:
		x.create(currently_selected)
		x.person.battle_index=state_machine.allies.find(x)
		for y in potential_container.get_children():
			if y.person==currently_selected:
				y.visible=false
		currently_selected=null
		
	
func remove_from_field(p:PersonSelectorButton):
	for x in potential_container.get_children():
		if x.person==p.person:
			x.visible=true
	p.reset()
	
func handle_input(event:InputEvent):
	if event.is_action_released("Right Click"):
		currently_selected=null
	
func exit():
	for x in state_machine.allies:
		x.clicked.disconnect(on_ally_slot_clicked)
		x.open.disconnect(on_ally_slot_open)
	potential_container_container.visible=false
	start_battle.visible=false

func _on_start_battle_pressed() -> void:
	state_finished.emit("CharacterSelect")
	
func get_state_name()->String:
	return "CharacterPositioning"
