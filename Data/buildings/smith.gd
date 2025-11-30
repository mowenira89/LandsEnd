class_name Smith extends Building

var fuel:Stuff
var fuel_buffer:float=0


func check_special()->bool:
	if fuel_buffer<=1:
		fuel_up()
	if fuel_buffer>0:
		fuel_buffer-=.5
		return true
	return false
		

func fuel_up():
	if district.territory.stockpile.remove_stuff(fuel,1):
		fuel_buffer+=fuel.qualities[Stuff.QUALITIES.Fuel]
		return true
	return false


func get_menu():
	GM.menus.smith_view.update_menu(self)
	
func get_production_options():
	var choices:Array[String]=['Craft']
	return choices
