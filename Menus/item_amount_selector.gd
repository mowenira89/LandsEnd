class_name ItemAmountSelector extends Control

var stuff:Stuff
var stockpile:Stockpile
var delimiter
@onready var stuff_selector: SelectorButton = $MarginContainer/MarginContainer/VBoxContainer/StuffSelector
@onready var slider: HSlider = $MarginContainer/MarginContainer/VBoxContainer/HBoxContainer/Slider
@onready var confirm: Button = $MarginContainer/MarginContainer/VBoxContainer/Confirm
var value:float
signal get_stuff_and_amount
@onready var has: Label = $MarginContainer/MarginContainer/VBoxContainer/HBoxContainer/Stockpile
@onready var giving: Label = $MarginContainer/MarginContainer/VBoxContainer/HBoxContainer/Giving
var dragging:bool=false

func _update_menu():
	update_menu(stockpile,delimiter)
	
func update_menu(s:Stockpile,d=null):
	stockpile=s
	delimiter=d
	stuff_selector.create(null)
	slider.editable=false
	GM.menus.switch_side_bottom(self)

func _on_stuff_selector_open(b:SelectorButton) -> void:
	var s:Array[Stuff] = []
	if delimiter!=null:
		var ss = stockpile.get_of_quality(delimiter)
		for x in ss:
			s.append(x)
	else:
		var ss = stockpile.stuff.keys()
		for x in ss:
			s.append(x)
	
	GM.menus.stuff_selector_screen.update_menu(s)
	var choice = await GM.menus.send_data
	if choice:
		var sss = RM.stuff[choice]
		stuff=sss
		stuff_selector.create(sss)
		slider.editable=true
		slider.min_value=1
		slider.max_value=stockpile.check_stuff_amount(sss)
	GM.menus.stuff_selector_screen.visible=false


func _on_confirm_pressed() -> void:
	get_stuff_and_amount.emit([stuff,slider.value])


func _on_x_pressed() -> void:
	get_stuff_and_amount.emit(null)


func _on_slider_drag_started() -> void:
	dragging=true


func update_labels():
	has.text=str(stockpile.check_stuff_amount(stuff)-slider.value)
	giving.text=str(slider.value)
	

func _on_slider_drag_ended(value_changed: bool) -> void:
	dragging=false
	
func _process(delta: float) -> void:
	if dragging:
		update_labels()
