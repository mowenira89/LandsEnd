class_name UnitActionMenu extends ColorRect


@onready var x_button: Button = $MarginContainer/x
@onready var main: HBoxContainer = $MarginContainer/HBoxContainer
@onready var actions: HBoxContainer = $MarginContainer/Actions


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
		var new_territory = await GM.board.get_target_territory(unit.current_territory,unit)
		if new_territory:
			unit.move(new_territory)
			unit.movements_allowed_this_turn-=1
		GM.board.enable_board()
		GM.menus.enable_buttons()
		x_button.disabled=false
		GM.menus.update_menus()


func _on_survey_pressed() -> void:
	var new = SurveyEvent.new()
	GM.board.disable_board()
	new.create()
	GM.menus.districts_view.set_for_selection(range(8))
	var district = await GM.menus.districts_view.send_targeted_district
	if district:
		new.make_plans(district,unit)
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
			GM.board.disable_board()
			GM.menus.disable_buttons()
			GM.menus.district_stats.build.visible=false
			var district = await GM.menus.districts_view.send_targeted_district
			if district:
				GM.menus.switch_side_bottom(GM.menus.unit_action_menu)
				GM.menus.switch_side_top(GM.menus.unit_view)
				GM.menus.build_menu.update_menu(district,unit.cargo)
			GM.menus.district_stats.build.visible=true	
			GM.board.enable_board()
			GM.menus.enable_buttons()


func _on_assimilate_pressed() -> void:
	var stocka=unit.cargo
	var stockb=unit.current_territory.stockpile
	var popa=unit.followers
	var popb=unit.current_territory.population
	GM.menus.exchange_window.update_menu(stocka,stockb,popa,popb)


func _on_more_pressed() -> void:
	main.visible=false
	actions.visible=true


func _on_less_pressed() -> void:
	main.visible=true
	actions.visible=false


func _on_forage_pressed() -> void:
	if unit.movements_allowed_this_turn>0:
		GM.board.disable_board()
		var dists = unit.current_territory.get_wild_district_indexes()
		GM.menus.districts_view.set_for_selection(dists)
		var district = await GM.menus.districts_view.send_targeted_district
		GM.menus.switch_side_top(GM.menus.unit_view)
		GM.menus.switch_side_bottom(GM.menus.unit_action_menu)
		if district:
			var new = ForageEvent.new()
			new.make_plans(district.territory,unit.cargo,district,null,unit)
			unit.add_event(new,district,null)
		GM.board.enable_board()
		GM.menus.update_menus()


func _on_hunt_pressed() -> void:
	if unit.movements_allowed_this_turn>0:
		GM.board.disable_board()
		var dists = unit.current_territory.get_wild_district_indexes()
		GM.menus.districts_view.set_for_selection(dists)
		var district = await GM.menus.districts_view.send_targeted_district
		GM.menus.switch_side_top(GM.menus.unit_view)
		GM.menus.switch_side_bottom(GM.menus.unit_action_menu)
		if district:
			var new = HuntEvent.new()
			new.make_plans(district,unit.cargo,district.territory,unit)
			unit.add_event(new,district,null)
		GM.board.enable_board()
		GM.menus.update_menus()


func _on_disband_pressed() -> void:
	var s = "Disband unit?"
	GM.menus.warning.create(s)
	var b = await GM.menus.warning.response
	if b:
		unit.disband()
		GM.menus.switch_side_bottom(GM.menus.pop_bottom_menu)
		GM.menus.switch_side_top(GM.menus.territory_stats)
