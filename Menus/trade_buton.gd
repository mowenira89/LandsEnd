class_name TradeButton extends Control

@onready var to_player: Button = $MarginContainer/HBoxContainer/ToPlayer
@onready var button: Button = $MarginContainer/HBoxContainer/Button
@onready var to_market: Button = $MarginContainer/HBoxContainer/ToMarket


enum MODES {PlayerInv,Selling,Buying,MarketInv}

signal removing

signal move_to_sell
signal move_to_buy
signal return_to_player
signal return_to_market

var stuff:Stuff
var amt:int=0
var mode
var building:Market

func create(m:MODES,s:Stuff,a:int,b:Market):
	building=b
	mode=m
	match m:
		MODES.PlayerInv:
			to_player.visible=false
			to_market.visible=true
		MODES.Selling:
			to_player.visible=true
			to_market.visible=false
		MODES.Buying:
			to_player.visible=false
			to_market.visible=true
		MODES.MarketInv:
			to_player.visible=true
			to_market.visible=false
	stuff=s
	amt+=a
	button.text=str(amt)+" "+stuff.name
	
func change_amt(a:int):
	amt+=a
	if amt==0:
		if mode==MODES.Buying or mode==MODES.Selling:
			removing.emit(self)
			queue_free()
		else:
			button.text=str(amt)+" "+stuff.name
	else:
		button.text=str(amt)+" "+stuff.name


func _on_to_player_pressed() -> void:
	if mode==MODES.MarketInv:
		if amt>0:
			change_amt(-1)	
			move_to_buy.emit(self)
	else:
		return_to_player.emit(self)
		change_amt(-1)
		if amt==0:
			removing.emit(self)

func _on_to_market_pressed() -> void:
	if mode==MODES.PlayerInv:
		if amt>0:
			move_to_sell.emit(self)
			change_amt(-1)
	else:
		change_amt(-1)
		return_to_market.emit(self)
		if amt==0:
			removing.emit(self)

func _on_button_gui_input(event: InputEvent) -> void:
	if event.is_action_released("Right Click"):
		removing.emit(self)
