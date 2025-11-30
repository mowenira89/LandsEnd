class_name RecipeButton extends MarginContainer

@onready var inputs: VBoxContainer = $HBoxContainer/Inputs
@onready var outputs: VBoxContainer = $HBoxContainer/Outputs


var recipe:Recipe
var building:Building
var index:int

var unit:Unit

signal emit_name

func create(r:Recipe,b:Building,i:int,u=null):
	recipe=r
	building=b
	index=i
	unit=u
	for x in r.inputs:
		var n = Label.new()
		var s = str(r.inputs[x])+" "+x.name
		inputs.add_child(n)
		n.text=s
		n.mouse_filter=Control.MOUSE_FILTER_IGNORE
	for x in r.outputs:
		var n = Label.new()
		var s = str(r.outputs[x])+" "+x.name
		outputs.add_child(n)
		n.text=s
		n.mouse_filter=Control.MOUSE_FILTER_IGNORE
	

func _on_gui_input(event: InputEvent) -> void:
	if event.is_action_released("Click"):	
		if building:
			building.producing_this_turn[index]=recipe
			building.turns_producing[index]=0
			emit_name.emit(recipe.name)
		else:
			var e = CraftEvent.new()
			e.make_plans(unit,recipe)
			unit.add_event(e)
			GM.menus.switch_side_bottom(GM.menus.unit_action_menu)
			GM.menus.update_menus()
			
			
