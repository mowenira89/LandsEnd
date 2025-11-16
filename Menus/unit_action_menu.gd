class_name UnitActionMenu extends ColorRect

@onready var grid: GridContainer = $MarginContainer/GridContainer
@onready var x_button: Button = $MarginContainer/x

var unit:Unit

func update_menu(u:Unit):
	unit=u
	GM.menus.switch_side_bottom(self)

func _update_menu():
	update_menu(unit)

func _on_move_pressed() -> void:
	GM.board.disable_board()
	x_button.disabled=true
	var new_territory = await GM.board.get_target_territory(unit.current_territory,unit)
	if new_territory:
		unit.move(new_territory)
		unit.movements_allowed_this_turn-=1
	GM.board.enable_board()
	x_button.disabled=false
	GM.menus.update_menus()


func _on_survey_pressed() -> void:
	GM.board.disable_board()
	var unsurveyed=[]
	var territory = unit.current_territory
	for x in territory.districts:
		GM.menus.districts_view.set_for_selection(unsurveyed)
		var district = await GM.menus.districts_view.send_targeted_district
		if district:
			var new_effect = SurveyEffect.new()
			unit.action_queue.append(new_effect)
			unit.movements_allowed_this_turn-=1
			new_effect.create(district,unit.leader)
	GM.menus.districts_view.untarget()
	GM.board.enable_board()
	GM.menus.switch_side_bottom(GM.menus.previous_side_bottom)
	GM.menus.update_menus()


func _on_x_pressed() -> void:
	GM.menus.switch_side_bottom(GM.menus.previous_side_bottom)
	


func _on_build_pressed() -> void:
	if GM.menus.districts_view.target_for_build():
		GM.board.disable_board()
		GM.menus.disable_buttons()
		var district = await GM.menus.districts_view.send_targeted_district
		if district:
			GM.menus.build_menu.update_menu(district,unit.cargo)
		GM.board.enable_board()
		GM.menus.enable_buttons()


func _on_assimilate_pressed() -> void:
	var stocka=unit.cargo
	var stockb=unit.current_territory.stockpile
	var popa=unit.followers
	var popb=unit.current_territory.population
	GM.menus.exchange_window.update_menu(stocka,stockb,popa,popb)
