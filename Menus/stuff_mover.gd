class_name StuffMover extends MarginContainer


@onready var stockpile: Label = $MarginContainer/HBoxContainer/VBoxContainer/Stockpile
@onready var stuff_label: Label = $MarginContainer/HBoxContainer/Stuff
@onready var party: Label = $MarginContainer/HBoxContainer/VBoxContainer2/Party


var stockpile_a:Stockpile
var stockpile_b:Stockpile

var stuff:Stuff

func create(s:Stuff,s1:Stockpile,s2:Stockpile):
	stuff_label.text = s.name
	stuff=s
	stockpile_a=s1
	stockpile_b=s2
	var stockpile_string = str(int(s1.stuff[stuff]))+"/"+str(stockpile_a.get_capacity(stuff)) if s1.stuff.has(s) else "0/"+str(stockpile_b.get_capacity(stuff))
	stockpile.text = stockpile_string
	party.text = str(int(s2.stuff[stuff]))+"/"+str(stockpile_b.get_capacity(stuff)) if s2.stuff.has(s) else "0/"+str(stockpile_b.get_capacity(stuff))
	
	
func return_to_stockpile(a:int):
	if stockpile_b.remove_stuff(stuff,a):
		stockpile_a.add_stuff(stuff,a)
		create(stuff,stockpile_a,stockpile_b)
	
	
func to_party(a:int):
	if stockpile_a.remove_stuff(stuff,a):
		stockpile_b.add_stuff(stuff,a)
		create(stuff,stockpile_a,stockpile_b)

func _on_ten_stock_pressed() -> void:
	if int(party.text)>=10:
		return_to_stockpile(10)

func _on_one_stock_pressed() -> void:
	if int(party.text)>=1:
		return_to_stockpile(1)

func _on_one_party_pressed() -> void:
	if int(party.text)>=1:
		to_party(1)

func _on_ten_party_pressed() -> void:
	if int(party.text)>=10:
		to_party(10)
