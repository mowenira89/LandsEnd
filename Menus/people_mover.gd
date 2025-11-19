class_name PeopleMover extends MarginContainer
@onready var a_num: Label = $PeopleMover/A_Num
@onready var label: Label = $PeopleMover/Label
@onready var b_num: Label = $PeopleMover/B_Num

var type
var pop_a:Population
var pop_b:Population

func create(t:Pop.CLASS,pop1:Population,pop2:Population):
	pop_a=pop1
	pop_b=pop2
	type=t
	label.text=Pop.CLASS.keys()[t]
	print(pop_a.get_pops(t))
	a_num.text=str(pop_a.get_pops(type))
	b_num.text=str(pop_b.get_pops(type))
	

func move_pops(from:Population,to:Population,a:int,c:Pop.CLASS):
	from.move_to(to,a,c)
	

func _on_ten_to_a_pressed() -> void:
	if pop_b.get_pops(type)>=10:
		move_pops(pop_b,pop_a,10,type)
		create(type,pop_a,pop_b)

func _on_one_to_a_pressed() -> void:
	if pop_b.get_pops(type)>=1:
		move_pops(pop_b,pop_a,1,type)
		create(type,pop_a,pop_b)
		
func _on_one_to_b_pressed() -> void:
	if pop_a.get_pops(type)>=1:
		move_pops(pop_a,pop_b,1,type)
		create(type,pop_a,pop_b)
		
func _on_ten_to_b_pressed() -> void:
	if pop_a.get_pops(type)>=10:
		move_pops(pop_a,pop_b,10,type)
		create(type,pop_a,pop_b)
