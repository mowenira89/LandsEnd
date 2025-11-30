class_name SchoolView extends Control

@onready var headmaster: PersonSelectorButton = $MarginContainer/MarginContainer/HBoxContainer/VBoxContainer/Headmaster
@onready var class_1: HBoxContainer = $MarginContainer/MarginContainer/HBoxContainer/VBoxContainer2/Class1
@onready var lecturer_1: PersonSelectorButton = $MarginContainer/MarginContainer/HBoxContainer/VBoxContainer2/Class1/lecturer1
@onready var lecture_1: ProductionContainer = $MarginContainer/MarginContainer/HBoxContainer/VBoxContainer2/Class1/lecture1
@onready var pupil_1_1: PersonSelectorButton = $MarginContainer/MarginContainer/HBoxContainer/VBoxContainer2/Class1/pupil1_1
@onready var pupil_1_2: PersonSelectorButton = $MarginContainer/MarginContainer/HBoxContainer/VBoxContainer2/Class1/pupil1_2
@onready var pupil_1_3: PersonSelectorButton = $MarginContainer/MarginContainer/HBoxContainer/VBoxContainer2/Class1/pupil1_3
@onready var class_2: HBoxContainer = $MarginContainer/MarginContainer/HBoxContainer/VBoxContainer2/Class2
@onready var lecturer_2: PersonSelectorButton = $MarginContainer/MarginContainer/HBoxContainer/VBoxContainer2/Class2/lecturer2
@onready var lecture_2: ProductionContainer = $MarginContainer/MarginContainer/HBoxContainer/VBoxContainer2/Class2/lecture2
@onready var pupil_2_1: PersonSelectorButton = $MarginContainer/MarginContainer/HBoxContainer/VBoxContainer2/Class2/pupil2_1
@onready var pupil_2_2: PersonSelectorButton = $MarginContainer/MarginContainer/HBoxContainer/VBoxContainer2/Class2/puplic2_2
@onready var pupil_2_3: PersonSelectorButton = $MarginContainer/MarginContainer/HBoxContainer/VBoxContainer2/Class2/pupil2_3
@onready var class_3: HBoxContainer = $MarginContainer/MarginContainer/HBoxContainer/VBoxContainer2/Class3
@onready var lecturer_3: PersonSelectorButton = $MarginContainer/MarginContainer/HBoxContainer/VBoxContainer2/Class3/lecturer3
@onready var lecture_3: ProductionContainer = $MarginContainer/MarginContainer/HBoxContainer/VBoxContainer2/Class3/lecture3
@onready var pupil_3_1: PersonSelectorButton = $MarginContainer/MarginContainer/HBoxContainer/VBoxContainer2/Class3/pupil3_1
@onready var pupil_3_2: PersonSelectorButton = $MarginContainer/MarginContainer/HBoxContainer/VBoxContainer2/Class3/pupil3_2
@onready var pupil_3_3: PersonSelectorButton = $MarginContainer/MarginContainer/HBoxContainer/VBoxContainer2/Class3/pupil3_3
@onready var class_4: HBoxContainer = $MarginContainer/MarginContainer/HBoxContainer/VBoxContainer2/Class4
@onready var lecturer_4: PersonSelectorButton = $MarginContainer/MarginContainer/HBoxContainer/VBoxContainer2/Class4/lecturer4
@onready var lecture_4: ProductionContainer = $MarginContainer/MarginContainer/HBoxContainer/VBoxContainer2/Class4/lecture4
@onready var pupil_4_1: PersonSelectorButton = $MarginContainer/MarginContainer/HBoxContainer/VBoxContainer2/Class4/pupil4_1
@onready var pupil_4_2: PersonSelectorButton = $MarginContainer/MarginContainer/HBoxContainer/VBoxContainer2/Class4/pupil4_2
@onready var pupil_4_3: PersonSelectorButton = $MarginContainer/MarginContainer/HBoxContainer/VBoxContainer2/Class4/pupil4_3

@onready var info: Label = $MarginContainer/MarginContainer/VBoxContainer2/Info
@onready var upgrade: Button = $MarginContainer/MarginContainer/VBoxContainer2/HBoxContainer/Upgrade
@onready var repair: Button = $MarginContainer/MarginContainer/VBoxContainer2/HBoxContainer/Repair
@onready var destroy: Button = $MarginContainer/MarginContainer/VBoxContainer2/HBoxContainer/Destroy

@onready var pupils = {
	0:[pupil_1_1,pupil_1_2,pupil_1_3],
	1:[pupil_2_1,pupil_2_2,pupil_2_3],
	2:[pupil_3_1,pupil_3_2,pupil_3_3],
	3:[pupil_4_1,pupil_4_2,pupil_4_3]
}

@onready var classes = {
	0:class_1,
	1:class_2,
	2:class_3,
	3:class_4
}

@onready var lecturers = {
	0:lecturer_1,
	1:lecturer_2,
	2:lecturer_3,
	3:lecturer_4
}

@onready var lectures = {
	0:lecture_1,
	1:lecture_2,
	2:lecture_3,
	3:lecture_4
}

var building:School

func _update_menu():
	update_menu(building)

func update_menu(b:School):
	building=b
	for x in classes:
		classes[x].visible=false
	for x in pupils:
		for y in pupils[x]:
			y.visible=false
	for x in 4:
		lectures[x].create(b,x,["Lecture"] as Array[String])
		
	for x in pupils:
		for y in 3:
			if building.pupils[x][y]:
				pupils[x][y].create(building.pupils[x][y])
		
	match building.level:
		1:
			classes[0].visible=true
			lecturers[0].visible=false			
		2:
			classes[0].visible=true
			lecturers[0].visible=false
		3:
			classes[0].visible=true
			classes[1].visible=true
			lecturers[0].visible=false
			lecturers[1].visible=false
		4:
			classes[0].visible=true
			classes[1].visible=true
			lecturers[0].visible=true
			lecturers[1].visible=true
			pupils[0][0].visible=true
			pupils[1][0].visible=true
		5:
			classes[0].visible=true
			classes[1].visible=true
			lecturers[0].visible=true
			lecturers[1].visible=true
			pupils[0][0].visible=true
			pupils[1][0].visible=true
			pupils[0][1].visible=true
			pupils[1][1].visible=true
		6:
			classes[0].visible=true
			classes[1].visible=true
			lecturers[0].visible=true
			lecturers[1].visible=true
			pupils[0][0].visible=true
			pupils[1][0].visible=true
			pupils[0][1].visible=true
			pupils[1][1].visible=true
		7:
			classes[0].visible=true
			classes[1].visible=true
			lecturers[0].visible=true
			lecturers[1].visible=true
			pupils[0][0].visible=true
			pupils[1][0].visible=true
			pupils[0][1].visible=true
			pupils[1][1].visible=true
			
		8:
			classes[0].visible=true
			classes[1].visible=true
			classes[2].visible=true
			lecturers[0].visible=true
			lecturers[1].visible=true
			lecturers[2].visible=true
			pupils[0][0].visible=true
			pupils[1][0].visible=true
			pupils[0][1].visible=true
			pupils[1][1].visible=true
			pupils[2][0].visible=true
			pupils[2][1].visible=true
		9:
			classes[0].visible=true
			classes[1].visible=true
			classes[2].visible=true
			lecturers[0].visible=true
			lecturers[1].visible=true
			lecturers[2].visible=true
			pupils[0][0].visible=true
			pupils[1][0].visible=true
			pupils[0][1].visible=true
			pupils[1][1].visible=true
			pupils[2][0].visible=true
			pupils[2][1].visible=true
		10:
			classes[0].visible=true
			classes[1].visible=true
			classes[2].visible=true
			classes[3].visible=true
			lecturers[0].visible=true
			lecturers[1].visible=true
			lecturers[2].visible=true
			for x in pupils:
				for y in pupils[x]:
					pupils[x][y].visible=true
	GM.menus.switch_side_top(self)

func _on_headmaster_open() -> void:
	GM.menus.npc_selector_menu.update_menu(building.district.territory,"NewBoss",Pop.CLASS.Artist)
	var choice = await GM.menus.send_data
	if choice:
		building.boss=choice

func _on_headmaster_removing() -> void:
	building.boss.remove_as_boss()
	building.boss=null


func get_lecturer(i:int):
	GM.menus.send_data.emit(null)
	GM.menus.npc_selector_menu.update_menu(building.district.territory,"Idle")
	var choice = await GM.menus.send_data
	if choice:
		building.lecturers[i]=choice
		choice.join_building(building)
	GM.menus.switch_side_bottom(GM.menus.districts_view)
	GM.menus.update_menus()

func remove_lecturer(i:int):
	building.lecturers[i].leave_building()
	building.lecturers[i]=null
	GM.menus.update_menus()
	

func _on_lecturer_1_open(b:PersonSelectorButton) -> void:
	get_lecturer(0)


func _on_lecturer_1_removing(b:PersonSelectorButton) -> void:
	remove_lecturer(0)



func _on_lecturer_2_open(b:PersonSelectorButton) -> void:
	get_lecturer(1)

func _on_lecturer_2_removing(b:PersonSelectorButton) -> void:
	remove_lecturer(1)


func _on_lecturer_3_open(b:PersonSelectorButton) -> void:
	get_lecturer(2)


func _on_lecturer_3_removing(b:PersonSelectorButton) -> void:
	remove_lecturer(2)
	


func _on_lecturer_4_open(b:PersonSelectorButton) -> void:
	get_lecturer(3)

func _on_lecturer_4_removing(b:PersonSelectorButton) -> void:
	remove_lecturer(3)


func add_pupil(c:int,s:int):
	GM.menus.send_data.emit(null)
	GM.menus.npc_selector_menu.update_menu(building.district.territory,"Idle")
	var choice = await GM.menus.send_data
	if choice is Person:
		choice.join_building(building)
		building.pupils[c][s]=choice
	GM.menus.switch_side_bottom(GM.menus.previous_side_bottom)
	GM.menus.update_menus()

func remove_pupil(c:int,s:int):
	building.pupils[c][s].leave_building()
	building.pupils[c][s]=null
	GM.menus.update_menus()

func _on_pupil_1_1_open(b:PersonSelectorButton) -> void:
	add_pupil(0,0)
	
func _on_pupil_1_2_open(b:PersonSelectorButton) -> void:
	add_pupil(0,1)

func _on_pupil_1_3_open(b:PersonSelectorButton) -> void:
	add_pupil(0,2)


func _on_pupil_1_1_removing(b:PersonSelectorButton) -> void:
	remove_pupil(0,0)

func _on_pupil_1_2_removing(b:PersonSelectorButton) -> void:
	remove_pupil(0,1)

func _on_pupil_1_3_removing(b:PersonSelectorButton) -> void:
	remove_pupil(0,2)
	


func _on_pupil_2_1_open(b:PersonSelectorButton) -> void:
	add_pupil(1,0)

func _on_puplic_2_2_open(b:PersonSelectorButton) -> void:
	add_pupil(1,1)

func _on_pupil_2_3_open(b:PersonSelectorButton) -> void:
	add_pupil(1,2)

func _on_pupil_2_3_removing(b:PersonSelectorButton) -> void:
	remove_pupil(1,2)

func _on_puplic_2_2_removing(b:PersonSelectorButton) -> void:
	remove_pupil(1,1)

func _on_pupil_2_1_removing(b:PersonSelectorButton) -> void:
	remove_pupil(1,0)
	


func _on_pupil_3_1_open(b:PersonSelectorButton) -> void:
	add_pupil(2,0)

func _on_pupil_3_1_removing(b:PersonSelectorButton) -> void:
	remove_pupil(2,0)

func _on_pupil_3_2_open(b:PersonSelectorButton) -> void:
	add_pupil(2,1)

func _on_pupil_3_3_open(b:PersonSelectorButton) -> void:
	add_pupil(2,2)

func _on_pupil_3_2_removing(b:PersonSelectorButton) -> void:
	remove_pupil(2,1)

func _on_pupil_3_3_removing(b:PersonSelectorButton) -> void:
	remove_pupil(2,2)


func _on_pupil_4_1_open(b:PersonSelectorButton) -> void:
	add_pupil(3,0)

func _on_pupil_4_2_open(b:PersonSelectorButton) -> void:
	add_pupil(3,1)

func _on_pupil_4_3_open(b:PersonSelectorButton) -> void:
	add_pupil(3,2)

func _on_pupil_4_1_removing(b:PersonSelectorButton) -> void:
	remove_pupil(3,0)

func _on_pupil_4_2_removing(b:PersonSelectorButton) -> void:
	remove_pupil(3,1)

func _on_pupil_4_3_removing(b:PersonSelectorButton) -> void:
	remove_pupil(3,2)


func _on_button_pressed() -> void:
	GM.menus.send_data.emit(null)
