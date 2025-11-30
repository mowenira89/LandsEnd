class_name MeleeBattleEvent extends BattleEvent



func make_plans(a:Person,t:Person):
	
	actor=a
	indv_target=t

	
	var actor_place = BattleManager.battle.state_machine.get_fighter_place(a)
	var target_place = BattleManager.battle.state_machine.get_fighter_place(t)
	if target_place in BattleManager.battle.state_machine.allies:
		priority=1
	else:
		if target_place in BattleManager.battle.state_machine.enemy_front_row:
			priority=2
		else:
			priority=3	
	
func apply():
	
	var actor_place = BattleManager.battle.state_machine.get_fighter_place(actor)
	var target_place = BattleManager.battle.state_machine.get_fighter_place(indv_target)
	if target_place in BattleManager.battle.state_machine.enemies:
		var index = BattleManager.battle.state_machine.enemies.find(target_place)
		if index%2==0:
			var front = index+1
			if BattleManager.battle.state_machine.enemies[front].person:
				indv_target=BattleManager.battle.state_machine.enemies[front].person
	
	if actor.alive and indv_target.alive:
		var actor_attack = actor.get_stat(Stats.STATS.Attack)
		var target_def = indv_target.get_stat(Stats.STATS.Defense)
		var actor_luck = actor.get_stat(Stats.STATS.Luck)
		actor_attack+=randf_range(0,actor_luck)
		var target_luck = indv_target.get_stat(Stats.STATS.Luck)
		target_def+=randf_range(0,target_luck)
		var damage = max(0,actor_attack-target_def)
		indv_target.take_damage(damage)
