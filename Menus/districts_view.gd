class_name DistrictsView extends ColorRect
@onready var grid_container: GridContainer = $GridContainer

var territory:Territory

func update_menu(t:Territory):
	territory=t
	var children = grid_container.get_children()
	for x in 8:
		children[x].create(territory.districts[x])
		
		
func _update_menu():
	update_menu(territory)
