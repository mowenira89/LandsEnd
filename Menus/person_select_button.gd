class_name PersonSelectorButton extends VBoxContainer

@onready var texture_rect: TextureRect = $PersonSelectorButton/TextureRect
@onready var battle_ordered: ColorRect = $PersonSelectorButton/BattleOrdered
@onready var selector: ColorRect = $PersonSelectorButton/Selector
@onready var button: Button = $PersonSelectorButton
@onready var label: Label = $Label
@onready var progress_bar: ProgressBar = $PersonSelectorButton/TextureRect/ProgressBar

@export var _size:int

signal removing
signal open
var person:Person
var unit
signal clicked
signal battle_order_revoked
signal targeted
signal on_hovered
signal on_unhovered

func create(p:Person):
	if _size:
		button.custom_minimum_size.x=_size
		button.custom_minimum_size.y=_size
		button.size.x=_size
		button.size.y=_size
	person=p
	if person!=null:
		texture_rect.texture=person.image
		texture_rect.visible=true
		progress_bar.max_value=person.get_stat(Stats.STATS.HP)
		progress_bar.min_value=0
		progress_bar.value=person.stats.current_hp
	
		var person_name = p.name
		var split = person_name.split(" ")
		if split.size()==2:
			label.text=split[0]+"\n"+split[1]
		else:
			label.text=person.name
	
	else:
		texture_rect.visible=false
	
	
	
	
		
func update_progress_bar():
	progress_bar.value=person.stats.current_hp
	print(person.stats.current_hp)
		
func _on_texture_rect_gui_input(event: InputEvent) -> void:
	if event.is_action_released("Right Click"):
		removing.emit(self)
	if event.is_action_released("Click"):
		clicked.emit(self)


func reset():
	person=null
	texture_rect.visible=false

func disable():
	button.disabled=true
	
func enable():
	button.disabled=false

func ordered():
	battle_ordered.visible=true
	
func order_revoked():
	battle_ordered.visible=false

func target():
	selector.visible=true
	
func untarget():
	selector.visible=false

func _on_battle_ordered_gui_input(event: InputEvent) -> void:
	if event.is_action_released("Right Click"):
		battle_order_revoked.emit(self)


func _on_selector_gui_input(event: InputEvent) -> void:
	if event.is_action_released("Click"):
		targeted.emit(self)
		print('selector getting clicked')


func _on_texture_rect_mouse_entered() -> void:
	on_hovered.emit(self)


func _on_texture_rect_mouse_exited() -> void:
	on_unhovered.emit(self)


func _on_person_selector_button_pressed() -> void:
	open.emit(self)


func _on_gui_input(event: InputEvent) -> void:
	if event.is_action_released("Click"):
		print('getting click')
