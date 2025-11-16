class_name DistrictsView extends ColorRect
@onready var grid_container: GridContainer = $GridContainer

var territory:Territory

signal send_targeted_district

func update_menu(t:Territory):
	territory=t
	var children = grid_container.get_children()
	for x in 8:
		children[x].create(territory.districts[x])
	GM.menus.switch_side_bottom(self)	
		
func _update_menu():
	update_menu(territory)

func get_buttons():
	return grid_container.get_children()

func set_for_selection(targetable:Array):
	_update_menu()
	for x in grid_container.get_children():
		if x.district.index in targetable:
			x.set_for_target()
			x.select_district.connect(send_target)
		
func target_for_build():
	_update_menu()
	var occupied = []
	for x in grid_container.get_children():
		if x.district.building or x.district.construction_time>0:
			occupied.append(x)
		else:
			x.set_for_target()
			x.select_district.connect(send_target) 
	if occupied.size()==8:
		return false
	return true
	
func send_target(d:District):
	send_targeted_district.emit(d)
	
func untarget():
	for x in grid_container.get_children():
		x.untarget()
		x.select_district.disconnect(send_target)
