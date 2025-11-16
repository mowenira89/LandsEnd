class_name ProductionContainer extends FoldableContainer

var building:Building
var index:int
@onready var container: VBoxContainer = $VBoxContainer


func create(b:Building,i:int,o:Array[String]):
	building=b
	index=i
	for x in o:
		var button = Button.new()
		container.add_child(button)
		button.text=x
		button.pressed.connect(func(nb=button):recieve_choice.call(nb.text))
		
func recieve_choice(t:String):
	title=t
	folded=true
	building.set_production(t,index)
	if title=="Craft":
		GM.menus.recipe_menu.update_menu(building,index)
	else:
		GM.remove_event(building.district.territory.name+str(building.district.index)+str(index)+"production_event")
		building.producing_this_turn[index]=title
		building.turns_producing[index]=0

func _on_gui_input(event: InputEvent) -> void:
	if event.is_action_released("Right Click"):
		title="----"
		building.producing_this_turn[index]=null
		building.turns_producing[index]=0



func _on_folding_changed(is_folded: bool) -> void:
	if title=="Craft":
		GM.menus.recipe_menu.update_menu(building,index)
