class_name ProductionContainer extends FoldableContainer

var building:Building
var index:int
@onready var container: VBoxContainer = $VBoxContainer


func create(b:Building,i:int,o:Array[String]):
	building=b
	index=i
	for x in container.get_children():
		x.queue_free()
	for x in o:
		var button = Button.new()
		container.add_child(button)
		button.text=x
		button.pressed.connect(func(nb=button):recieve_choice.call(nb.text))
	var s = b.producing_this_turn[i]
	if s is Recipe:
		title=s.name
	elif s is String:
		title=s
		if s=="Make Offering":
			title="Offering "+building.offerings[index]
	elif s is ObtainEvent:
		title = "Obtaining "+s.species.name
	
	else:
		title="---"
		
func recieve_choice(t:String):
	title=t
	folded=true
	building.set_production(t,index)
	if title=="Craft":
		GM.menus.recipe_menu.update_menu(building,index)
	elif title=="Obtain":
		GM.menus.obtain_screen.update_menu(building.district,building,null)
		var o = await GM.menus.send_data
		if o:
			var event = ObtainEvent.new()
			event.make_plans(building.district,o,building,null)
			building.producing_this_turn[index]=event
	elif title=="Lecture":
		
		var a:Array[Lecture] = []
		for x in building.lectures:
			a.append(x)
		if building.lecturers[index]:
			for x in building.lecturers[index].lectures:
				a.append(x)
		GM.menus.lecture_select_window.update_menu(a)
	else:
		building.producing_this_turn[index]=title
		building.turns_producing[index]=0

func _on_gui_input(event: InputEvent) -> void:
	if event.is_action_released("Right Click"):
		title="----"
		building.producing_this_turn[index]=null
		building.turns_producing[index]=0
