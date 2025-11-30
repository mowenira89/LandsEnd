class_name MarketView extends Control

@onready var player_inv: VBoxContainer = $MarginContainer/MarginContainer/HBoxContainer/ScrollContainer/PlayerInv
@onready var selling: VBoxContainer = $MarginContainer/MarginContainer/HBoxContainer/VBoxContainer/ScrollContainer/Selling
@onready var buying: VBoxContainer = $MarginContainer/MarginContainer/HBoxContainer/VBoxContainer/ScrollContainer2/Buying
@onready var market_inv: VBoxContainer = $MarginContainer/MarginContainer/HBoxContainer/ScrollContainer2/MarketInv

var building:Market

const TRADE_BUTTON = preload("res://Menus/trade_buton.tscn")

var player_buttons = {}
var shop_buttons = {}

var selling_buttons = {}
var buying_buttons = {}

var player_value:float
var shop_value:float
@onready var desc: Label = $MarginContainer/MarginContainer/HBoxContainer/VBoxContainer/TradeDescription


func _update_menu():
	update_menu(building)

func update_menu(b:Market):
	desc.text="Make your offer."
	building=b
	for x in player_inv.get_children():
		x.queue_free()
	for x in market_inv.get_children():
		x.queue_free()
	for x in buying.get_children():
		x.queue_free()
	for x in selling.get_children():
		x.queue_free()
	var stockpile = building.district.territory.stockpile
	var orders = [stockpile.storeroom_order,stockpile.food_order,stockpile.animal_order]
	for x in orders:
		for y in x:
			var new = TRADE_BUTTON.instantiate()
			player_inv.add_child(new)
			player_buttons[y]=new
			new.create(TradeButton.MODES.PlayerInv,y,stockpile.stuff[y],building)
			new.move_to_sell.connect(moving_to_sell)

	for x in building.stock.stuff.keys():
		var new = TRADE_BUTTON.instantiate()
		market_inv.add_child(new)
		shop_buttons[x]=new
		new.move_to_buy.connect(moving_to_buy)

	GM.menus.switch_side_top(self)

func process_removal(b:TradeButton):
	var mode = b.mode
	var stuff = b.stuff
	match mode:
		TradeButton.MODES.Buying:
			shop_buttons[stuff].change_amt(b.amt)
			buying_buttons.erase(stuff)
			b.queue_free()
		TradeButton.MODES.Selling:
			player_buttons[stuff].change_amt(b.amt)
			selling_buttons.erase(stuff)
			b.queue_free()
			
func moving_to_sell(b:TradeButton):
	
	var stuff = b.stuff
	if selling_buttons.has(stuff):
		selling_buttons[stuff].change_amt(1)
	else:
		var new = TRADE_BUTTON.instantiate()
		selling.add_child(new)
		new.create(TradeButton.MODES.Selling,stuff,1,building)
		new.return_to_player.connect(return_to_player)
		selling_buttons[stuff]=new
	calculate_values()
		
		
func moving_to_buy(b:TradeButton):
	if buying_buttons.has(b.stuff):
		selling_buttons[b.stuff].change_amt(1)
	else:
		var new = TRADE_BUTTON.instantiate()
		buying.add_child(new)
		new.create(TradeButton.MODES.Buying,b.stuff,1,building)
		new.return_to_market.connect(return_to_market)
	calculate_values()
		
func return_to_player(b:TradeButton):
	player_buttons[b.stuff].change_amt(1)
	calculate_values()
	
func return_to_market(b:TradeButton):
	shop_buttons[b.stuff].change_amt(1)
	calculate_values()


func calculate_values():
	player_value=0
	shop_value=0
	for x in selling_buttons.values():
		player_value+=x.stuff.value*x.amt
	for x in buying_buttons.values():
		shop_value+=x.stuff.value*x.amt
	
	var value = player_value-shop_value
	if value <-50:
		desc.text="Ludicrous!"
	elif value <-1:
		desc.text="Not quite"
	elif value >= 0 and value <= 5:
		desc.text="Fair"
	elif value>5:
		desc.text="Generous!" 	
	
	
