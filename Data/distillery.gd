class_name Distillery extends Building

var container:Stuff

func check_special():
	var amt = district.territory.stockpile.check_stuff_amount(container)
	if amt<1:
		return false
	else:
		district.territory.stockpile.remove_stuff(container,1)
		return true

func get_menu():
	GM.menus.distillery_menu.update_menu(self)

func get_production_options():
	var r:Array[String]=['Craft']
	return r
	
