class_name RecipeMenu extends ColorRect

var building:Building
var index:int
var unit:Unit
@onready var recipes_container: VBoxContainer = $MarginContainer/ScrollContainer/RecipesContainer

const RECIPE_BUTTON = preload("res://Menus/recipe_button.tscn")

signal emit_name

func update_menu(b:Building,i:int,u:Unit=null):
	building=b
	index=i
	unit=u
	for x in recipes_container.get_children():
		x.queue_free()
	var recipes 
	if unit:
		recipes=unit.recipes
	else:
		recipes = building.this_building_recipes.values()
	for x in recipes:
		if x.unlocked:
			var n = RECIPE_BUTTON.instantiate()
			recipes_container.add_child(n)
			n.create(x,building,index,unit)
			n.emit_name.connect(_emit_name)
	GM.menus.switch_side_bottom(self)
	
func _emit_name(t:String):
	GM.menus.send_data.emit(t,index)
	GM.menus.switch_side_bottom(GM.menus.previous_side_bottom)
	GM.menus.update_menus()
		
func _update_menu():
	update_menu(building,index)


func _on_button_pressed() -> void:
	GM.menus.send_data.emit(null)
