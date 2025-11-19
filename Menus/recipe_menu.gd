class_name RecipeMenu extends ColorRect

var building:Building
var index:int
@onready var recipes_container: VBoxContainer = $MarginContainer/ScrollContainer/RecipesContainer

const RECIPE_BUTTON = preload("res://Menus/recipe_button.tscn")

signal emit_name

func update_menu(b:Building,i:int):
	building=b
	index=i
	for x in recipes_container.get_children():
		x.queue_free()
	for x in building.this_building_recipes.values():
		if x.unlocked:
			var n = RECIPE_BUTTON.instantiate()
			recipes_container.add_child(n)
			n.create(x,building,index)
			n.emit_name.connect(_emit_name)
	GM.menus.switch_side_top(self)
	
func _emit_name(t:String):
	emit_name.emit(t,index)
	GM.menus.switch_side_top(GM.menus.previous_side_top)
	GM.menus.update_menus()
		
func _update_menu():
	update_menu(building,index)
