class_name BattleScreen extends ColorRect
 
var allies:Unit
var enemies:Unit
@onready var state_machine: BattleStateMachine = $StateMachine
@onready var start: MarginContainer = $Start
@onready var enemies_grid: GridContainer = $Start/VBoxContainer/HBoxContainer/Enemies
@onready var allies_grid: GridContainer = $Start/VBoxContainer/HBoxContainer/Allies
@onready var margin_container: MarginContainer = $MarginContainer
@onready var enemy_info: InfoHoverBox = $Start/VBoxContainer/HBoxContainer/EnemyInfo/EnemyInfo
@onready var ally_info: InfoHoverBox = $Start/VBoxContainer/HBoxContainer/AllyInfo/AllyInfo
var ally_power:float
var enemy_power:float
@onready var enemy_power_label: Label = $Start/VBoxContainer/HBoxContainer/EnemyInfo/EnemyPowerLabel
@onready var ally_power_label: Label = $Start/VBoxContainer/HBoxContainer/AllyInfo/AllyPowerLabel
@onready var fight: Button = $Start/VBoxContainer/HBoxContainer/VBoxContainer/Fight
@onready var autoresolve: Button = $Start/VBoxContainer/HBoxContainer/VBoxContainer/Autoresolve
@onready var flee: Button = $Start/VBoxContainer/HBoxContainer/VBoxContainer/Flee
@onready var finish: Button = $Start/VBoxContainer/HBoxContainer/VBoxContainer/Finish


const NPC_SELECTOR = preload("res://Menus/PersonSelectButton.tscn")

func _ready():
	BattleManager.battle=self
	
	
func init_battle(a:Unit,e:Person):
	allies=a
	enemies=e.unit
	
	ally_power=allies.get_power()
	enemy_power=enemies.get_power()
	autoresolve.visible=true
	flee.visible=true
	fight.visible=true
	finish.visible=false
	enemy_power_label.visible=true
	ally_power_label.visible=true
	enemy_power_label.text="Power: "+str(enemy_power)
	ally_power_label.text="Power "+str(ally_power)
	
	
	
	visible=true
	margin_container.visible=false
	start.visible=true
	
	set_combatants()
	
func set_combatants():
	for x in enemies_grid.get_children():
		x.queue_free()
	for x in allies_grid.get_children():
		x.queue_free()
		
	create_enemy(enemies.leader)
	for x in enemies.companions:
		create_enemy(x)
	for x in enemies.guard:
		create_enemy(x)

	create_ally(allies.leader)
	for x in allies.companions:
		create_ally(x)
	for x in allies.guard:
		create_ally(x)
		
	

func create_enemy(p:Person):
	if p:
		var new:PersonSelectorButton = NPC_SELECTOR.instantiate()
		enemies_grid.add_child(new)
		new.create(p)
		new.on_hovered.connect(set_enemy_info)
		new.on_unhovered.connect(func(_x):enemy_info.text="")
	
func create_ally(p:Person):
	if p:
		var new:PersonSelectorButton = NPC_SELECTOR.instantiate()
		allies_grid.add_child(new)
		new.create(p)
		new.on_hovered.connect(set_ally_info)
		new.on_unhovered.connect(func(_x):ally_info.text="")
		
func set_ally_info(p:PersonSelectorButton):
	ally_info.create(p.person)

func set_enemy_info(p:PersonSelectorButton):
	enemy_info.create(p.person)


func _on_flee_pressed() -> void:
	visible=false

func _on_autoresolve_pressed() -> void:
	var chance_win = ally_power/(ally_power+enemy_power)
	var chance_lose = 1-chance_win
	
	var winner = allies if randf()<chance_win else enemies
	
	var total_power = ally_power+enemy_power
	var loss_share_A = enemy_power/total_power
	var loss_share_B = ally_power/total_power

	var brutality = randf()
	
	for x:Person in enemies.get_individuals():
		var base_damage = x.stats.total_hp*loss_share_B*brutality
		x.take_damage(base_damage)

func end_battle():
	margin_container.visible=false
	start.visible=true
	enemy_power_label.visible=false
	ally_power_label.visible=false
	
	for x in enemies_grid.get_children():
		x.queue_free()
	for x in allies_grid.get_children():
		x.queue_free()
		
	create_enemy(enemies.leader)
	for x in enemies.companions:
		create_enemy(x)
	for x in enemies.guard:
		create_enemy(x)

	create_ally(allies.leader)
	for x in allies.companions:
		create_ally(x)
	for x in allies.guard:
		create_ally(x)

func _on_fight_pressed() -> void:
	start.visible=false
	margin_container.visible=true
	state_machine.state_finished("CharacterPositioning")
