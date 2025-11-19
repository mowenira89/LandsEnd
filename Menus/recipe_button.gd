class_name RecipeButton extends MarginContainer

@onready var inputs: VBoxContainer = $HBoxContainer/Inputs
@onready var stuff: Label = $HBoxContainer/Stuff
@onready var outputs: VBoxContainer = $HBoxContainer/Outputs


var recipe:Recipe
var building:Building
var index:int

signal emit_name

func create(r:Recipe,b:Building,i:int):
	recipe=r
	building=b
	index=i
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
	stuff.text=r.name


func _on_gui_input(event: InputEvent) -> void:
	if event.is_action_released("Click"):	
		building.producing_this_turn[index]=recipe
		building.turns_producing[index]=0
		emit_name.emit(recipe.name)
		print('clicked')
