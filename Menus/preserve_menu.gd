class_name PreserveMenu extends Control

var building:Farm

enum COMPONENTS{Preservative,Preserve,Containment}

@onready var preservative: SelectorButton = $MarginContainer/VBoxContainer/HBoxContainer/VBoxContainer/Preservative
@onready var preserve: SelectorButton = $MarginContainer/VBoxContainer/HBoxContainer/VBoxContainer2/Preserve
@onready var container: SelectorButton = $MarginContainer/VBoxContainer/HBoxContainer/VBoxContainer3/Container

@onready var selections_container: HBoxContainer = $MarginContainer/VBoxContainer/ScrollContainer/CenterContainer/SelectionsContainer
@onready var selections: GridContainer = $MarginContainer/VBoxContainer/ScrollContainer/CenterContainer/SelectionsContainer/Selections

@onready var selectors = {
	COMPONENTS.Preservative:preservative,
	COMPONENTS.Preserve:preserve,
	COMPONENTS.Containment:container,
	}

var index:int
var setting:COMPONENTS

func _update_menu():
	update_menu(building,index)
		
	
func update_menu(b:Farm,i:int):
	building=b
	if !b.preserving.has(i):
		b.preserving[i]={
			COMPONENTS.Preservative:null,
			COMPONENTS.Preserve:null,
			COMPONENTS.Containment:null,
		}
	else:
		var p = b.preserving[i]
		for x in selectors:
			selectors[x].create(p[x])
	GM.menus.switch_side_bottom(self)

func open_sub_menu(k:COMPONENTS):
	for x in selections.get_children():
		x.queue_free()
	var s = []
	setting=k
	match k:
		COMPONENTS.Preservative:
			var stuff = ["Vinegar","Honey"]
			for x in stuff:
				s.append(RM.stuff[x])
		COMPONENTS.Containment:
			var stuff = ["Barrel","Amphora"]
			for x in stuff:
				s.append(RM.stuff[x])
		COMPONENTS.Preserve:
			s=building.district.territory.stockpile.get_of_quality(Stuff.QUALITIES.Preservable).keys()
	selections_container.visible=true
	for x in s:
		if building.district.territory.stockpile.check_stuff_amount(x)>=1:
			var b = Button.new()
			selections.add_child(b)
			b.text=x.name
			b.pressed.connect(func(z=b.text):GM.menus.send_data.emit.call(z))		
			

func _on_preservative_open(b:SelectorButton) -> void:
	open_sub_menu(COMPONENTS.Preservative)
	var p = await GM.menus.send_data
	if p:
		building.preserving[index][COMPONENTS.Preservative]=RM.stuff[p]
	selections_container.visible=false
	GM.menus.update_menus()

func _on_preservative_removing(b:SelectorButton) -> void:
	b.create(null)
	building.preserving[index][COMPONENTS.Preservative]=null
	GM.menus.send_data.emit(null)
	GM.menus.update_menus()

func _on_preserve_open(b:SelectorButton) -> void:
	open_sub_menu(COMPONENTS.Preserve)
	var p = await GM.menus.send_data
	if p:
		building.preserving[index][COMPONENTS.Preserve]=RM.stuff[p]
	selections_container.visible=false
	GM.menus.update_menus()

func _on_preserve_removing(b:SelectorButton) -> void:
	b.create(null)
	building.preserving[index][COMPONENTS.Preserve]=null
	GM.menus.send_data.emit(null)
	GM.menus.update_menus()

func _on_container_open(b:SelectorButton) -> void:
	open_sub_menu(COMPONENTS.Containment)
	var p = await GM.menus.send_data
	if p:
		building.preserving[index][COMPONENTS.Containment]=RM.stuff[p]
	selections_container.visible=false
	GM.menus.update_menus()

func _on_container_removing(b:SelectorButton) -> void:
	b.create(null)
	building.preserving[index][COMPONENTS.Containment]=null
	GM.menus.send_data.emit(null)
	GM.menus.update_menus()
	
func _on_submenu_x_pressed() -> void:
	GM.menus.send_data.emit(null)
	selections_container.visible=false
	GM.menus.send_data.emit(null)
	GM.menus.update_menus()


func _on_x_out_pressed() -> void:
	visible=false
