class_name ResolveBattleState extends BattleState

var ordering = {
	0:[],
	1:[],
	2:[],
	3:[],
}
@onready var vbox: VBoxContainer = $"../../MarginContainer/MarginContainer/ScrollContainer/VBoxContainer"

func enter():
	get_fresh_dict()
	for x in state_machine.orders:
		ordering[state_machine.orders[x].priority].append(state_machine.orders[x])
	for x in ordering:
		ordering[x].sort_custom(sort_function)
	
	var priorities = [0,1,2,3]
	for x in priorities:
		for y in ordering[x]:
			y.apply()
			state_machine.update_progress_bars()
			await get_tree().create_timer(.5).timeout
	
	var enemies_alive:bool=false
	var players_alive:bool=false
	
	for x in state_machine.enemies:
		if x.person:
			enemies_alive=true
			break
	for x in state_machine.allies:
		if x.person:
			players_alive=true
			break
	if enemies_alive and players_alive:
		state_finished.emit("CharacterSelect")
	else:
		state_finished.emit("EndState")
	
	
	
func sort_function(a:BattleEvent,b:BattleEvent):
	return a.actor.get_stat(Stats.STATS.Speed)>b.actor.get_stat(Stats.STATS.Speed)
	
	
func get_fresh_dict():
	ordering = {
		0:[],
		1:[],
		2:[],
		3:[],
	}

func get_state_name()->String:
	return "Resolve"
	
func exit():
	for x in state_machine.allies:
		if x.person:
			x.order_revoked()
	state_machine.orders.clear()
