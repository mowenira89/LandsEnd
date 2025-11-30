class_name UnitActionMenu extends ColorRect


@onready var x_button: Button = $MarginContainer/x


var unit:Unit

func update_menu(u:Unit):
	unit=u
	GM.menus.switch_side_bottom(self)

func _update_menu():
	update_menu(unit)

func _on_move_pressed() -> void:
	if unit.movements_allowed_this_turn>0 and unit.action_queue.is_empty():
		GM.board.disable_board()
		GM.menus.disable_buttons()
		x_button.disabled=true
		GM.board.get_target_territory(unit.current_territory,unit)
		var new_territory = await GM.menus.send_data
		if new_territory:
			unit.move(new_territory)
		GM.board.enable_board()
		GM.menus.enable_buttons()
		x_button.disabled=false
		GM.menus.update_menus()


func _on_survey_pressed() -> void:
	var new = SurveyEvent.new()
	GM.menus.districts_view.set_for_selection(range(8))
	var district = await GM.menus.send_data
	if district:
		new.make_plans(unit.followers,district,unit)
		unit.add_event(new,district)
	GM.menus.switch_side_bottom(GM.menus.unit_action_menu)
	GM.menus.switch_side_top(GM.menus.unit_view)
	GM.board.enable_board()
	GM.menus.update_menus()

func _on_x_pressed() -> void:
	GM.menus.switch_side_bottom(GM.menus.pop_bottom_menu)
	


func _on_build_pressed() -> void:
	if unit.movements_allowed_this_turn>0:
		if GM.menus.districts_view.target_for_build():
			GM.menus.district_stats.build.visible=false
			var district = await GM.menus.send_data
			if district:
				GM.menus.switch_side_bottom(GM.menus.unit_action_menu)
				GM.menus.switch_side_top(GM.menus.unit_view)
				GM.menus.build_menu.update_menu(district,unit.cargo)
			GM.menus.district_stats.build.visible=true	
		


func _on_forage_pressed() -> void:
	if unit.movements_allowed_this_turn>0:
		var dists = unit.current_territory.get_wild_district_indexes()
		GM.menus.districts_view.set_for_selection(dists)
		var district = await GM.menus.send_data
		GM.menus.switch_side_top(GM.menus.unit_view)
		GM.menus.switch_side_bottom(GM.menus.unit_action_menu)
		if district:
			var new = ForageEvent.new()
			new.make_plans(unit.followers,null,unit,district)
			unit.add_event(new,district,null)
		GM.menus.update_menus()


func _on_hunt_pressed() -> void:
	if unit.movements_allowed_this_turn>0:
		var dists = unit.current_territory.get_wild_district_indexes()
		GM.menus.districts_view.set_for_selection(dists)
		var district = await GM.menus.send_data
		GM.menus.switch_side_top(GM.menus.unit_view)
		GM.menus.switch_side_bottom(GM.menus.unit_action_menu)
		if district:
			var new = HuntEvent.new()
			new.make_plans(unit.followers,null,unit,district)
			unit.add_event(new,district,null)
		GM.menus.update_menus()


func _on_disband_pressed() -> void:
	var s = "Disband unit?"
	GM.menus.warning.create(s)
	var b = await GM.menus.warning.response
	if b:
		unit.disband()
		GM.menus.switch_side_bottom(GM.menus.pop_bottom_menu)
		GM.menus.switch_side_top(GM.menus.territory_stats)


func _on_chop_wood_pressed() -> void:
	if unit.movements_allowed_this_turn>0:
		var dists = unit.current_territory.get_wild_district_indexes()
		GM.menus.districts_view.set_for_selection(dists)
		var district = await GM.menus.send_data
		GM.menus.switch_side_top(GM.menus.unit_view)
		GM.menus.switch_side_bottom(GM.menus.unit_action_menu)
		if district:
			var new = ChopWoodEvent.new()
			new.make_plans(unit.followers,district,unit)
			unit.add_event(new,district,null)
		GM.menus.update_menus()


func _on_fish_pressed() -> void:
	if unit.movements_allowed_this_turn>0:
		var dists = unit.current_territory.get_river_districts()
		GM.menus.districts_view.set_for_selection(dists)
		var district = await GM.menus.send_data
		GM.menus.switch_side_top(GM.menus.unit_view)
		GM.menus.switch_side_bottom(GM.menus.unit_action_menu)
		if district:
			var new = FishingEvent.new()
			new.make_plans(unit.followers,district,unit)
			unit.add_event(new,district,null)
		GM.menus.update_menus()


func _on_craft_pressed() -> void:
	if unit.movements_allowed_this_turn>0:
		GM.menus.recipe_menu.update_menu(null,0,unit)
		

func _on_automate_toggled(toggled_on: bool) -> void:
	if toggled_on:
		unit._automate()
	else:
		unit.deautomate()


func _on_exchange_pressed() -> void:
	var stocka=unit.cargo
	var stockb=unit.current_territory.stockpile
	var popa=unit.followers
	var popb=unit.current_territory.population
	GM.menus.exchange_window.update_menu(stocka,stockb,popa,popb)


func _on_stats_pressed() -> void:
	pass # Replace with function body.


func _on_commune_pressed() -> void:
	pass # Replace with function body.


func _on_dig_pressed() -> void:
	var dig = DeliverStuffEvent.new()
	GM.menus.districts_view.set_for_selection(range(8))
	var district = await GM.menus.send_data
	GM.menus.switch_side_top(GM.menus.unit_view)
	GM.menus.switch_side_bottom(GM.menus.unit_action_menu)
	if district:
		var productive=unit.get_prowess(Person.PROWESS.Productive)/10
		dig.make_plans(district,unit.cargo,1+productive)
		unit.add_event(dig,district)
	GM.menus.update_menus()


func _on_obtain_pressed() -> void:
	var obtain = ObtainEvent.new()
	var ds = unit.current_territory.get_wild_district_indexes()
	GM.menus.send_data.emit(null)
	GM.menus.districts_view.set_for_selection(ds)
	var district = await GM.menus.send_data
	if district:
		GM.menus.obtain_screen.update_menu(district,null,unit)
		var o = await GM.menus.send_data
		if o:
			obtain.make_plans(district,o,null,unit)
			unit.add_event(obtain,district)
		GM.menus.update_menus()


func _on_attack_pressed() -> void:
	GM.menus.npc_selector_menu.update_menu(unit.current_territory,"Foes",-1,unit.leader)
	var choice = await GM.menus.send_data
	if choice:
		BattleManager.battle.init_battle(unit,choice)
	GM.menus.switch_side_bottom(GM.menus.unit_action_menu)
