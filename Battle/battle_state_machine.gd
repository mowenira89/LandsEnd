class_name BattleStateMachine extends Node


@onready var enemies_0: PersonSelectorButton = $"../MarginContainer/MarginContainer/VBoxContainer/HBoxContainer/EnemiesRow2/Enemies0"
@onready var enemies_2: PersonSelectorButton = $"../MarginContainer/MarginContainer/VBoxContainer/HBoxContainer/EnemiesRow2/Enemies2"
@onready var enemies_4: PersonSelectorButton = $"../MarginContainer/MarginContainer/VBoxContainer/HBoxContainer/EnemiesRow2/Enemies4"
@onready var enemies_6: PersonSelectorButton = $"../MarginContainer/MarginContainer/VBoxContainer/HBoxContainer/EnemiesRow2/Enemies6"
@onready var enemies_1: PersonSelectorButton = $"../MarginContainer/MarginContainer/VBoxContainer/HBoxContainer/EnemiesRow1/Enemies1"
@onready var enemies_3: PersonSelectorButton = $"../MarginContainer/MarginContainer/VBoxContainer/HBoxContainer/EnemiesRow1/Enemies3"
@onready var enemies_5: PersonSelectorButton = $"../MarginContainer/MarginContainer/VBoxContainer/HBoxContainer/EnemiesRow1/Enemies5"
@onready var enemies_7: PersonSelectorButton = $"../MarginContainer/MarginContainer/VBoxContainer/HBoxContainer/EnemiesRow1/Enemies7"
@onready var allies_0: PersonSelectorButton = $"../MarginContainer/MarginContainer/VBoxContainer/HBoxContainer/Fighters/Allies0"
@onready var allies_2: PersonSelectorButton = $"../MarginContainer/MarginContainer/VBoxContainer/HBoxContainer/Fighters/Allies2"
@onready var allies_4: PersonSelectorButton = $"../MarginContainer/MarginContainer/VBoxContainer/HBoxContainer/Fighters/Allies4"
@onready var allies_6: PersonSelectorButton = $"../MarginContainer/MarginContainer/VBoxContainer/HBoxContainer/Fighters/Allies6"
@onready var allies_1: PersonSelectorButton = $"../MarginContainer/MarginContainer/VBoxContainer/HBoxContainer/Fighters2/Allies1"
@onready var allies_3: PersonSelectorButton = $"../MarginContainer/MarginContainer/VBoxContainer/HBoxContainer/Fighters2/Allies3"
@onready var allies_5: PersonSelectorButton = $"../MarginContainer/MarginContainer/VBoxContainer/HBoxContainer/Fighters2/Allies5"
@onready var allies_7: PersonSelectorButton = $"../MarginContainer/MarginContainer/VBoxContainer/HBoxContainer/Fighters2/Allies7"

@onready var enemies:Array[PersonSelectorButton] = [enemies_0,enemies_1,enemies_2,enemies_3,enemies_4,enemies_5,enemies_6,enemies_7]
@onready var allies:Array[PersonSelectorButton] = [allies_0,allies_1,allies_2,allies_3,allies_4,allies_5,allies_6,allies_7,]

@onready var enemy_front_row:Array[PersonSelectorButton] = [enemies_1,enemies_3,enemies_5,enemies_7]
@onready var enemy_back_row:Array[PersonSelectorButton] = [enemies_0,enemies_2,enemies_4,enemies_6]

@onready var allies_front_row:Array[PersonSelectorButton] = [allies_0,allies_2,allies_4,allies_6]
@onready var allies_back_row:Array[PersonSelectorButton] = [allies_1,allies_3,allies_5,allies_7]

var orders:Dictionary[Person,BattleEvent] = {}

var selected_fighter:Person

var states = {}
var current_state:BattleState

signal orders_changed

func _ready():
	for x in get_children():
		if x is BattleState:
			states[x.get_state_name()]=x
			x.state_machine=self
			x.state_finished.connect(state_finished)



func state_finished(next_state:String):
	if states.has(next_state):
		change_state(states[next_state])
	
func _process(delta: float) -> void:
	if current_state:
		current_state.process(delta)
		
func _input(event: InputEvent) -> void:
	if current_state:
		current_state.handle_input(event)
		
func change_state(new_state:BattleState):
	if current_state:
		current_state.exit()
		
	current_state=new_state
	new_state.enter()
	
func get_fighter_place(p:Person):
	for x in allies:
		if x.person==p:
			return x
	for x in enemies:
		if x.person==p:
			return x

func add_order(e:BattleEvent):
	orders[e.actor]=e
	orders[e.actor].battle_init(allies,enemies)
	orders_changed.emit()

func check_orders_empty():
	for x in orders:
		if orders[x]!=null:
			return true

func move(a:Person,t:PersonSelectorButton):
	for x in allies:
		if x.person==a:
			x.create(null)
			break
	t.create(a)
	
func get_place(p:Person):
	for x in allies:
		if x.person==p:
			return x
	for x in enemies:
		if x.person==p:
			return x

func update_progress_bars():
	for x in allies:
		if x.person:
			x.update_progress_bar()
	for x in enemies:
		if x.person:
			x.update_progress_bar()
