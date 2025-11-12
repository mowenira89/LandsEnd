class_name StockpileMenu extends ColorRect

var territory:Territory

const RED_GREEN_BUTTON = preload("uid://6ksjvhk3tld")


func update_menu(t:Territory):
	var food = t.stockpile.get_food()
	
func _update_menu():
	update_menu(territory)
	
func alter_useage(x,b):
	if x is Food:
		pass
	
