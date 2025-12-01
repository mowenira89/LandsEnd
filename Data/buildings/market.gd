class_name Market extends Building

#the market should show only items found in the territory until it is upgraded to a merchant

var stock:Stockpile

var restock_in:int=15

func create(d:District):
	super(d)
	stock=Stockpile.new()
	stock.create(null,null,self)
	restock()
	
func end_turn():
	super()
	restock_in-=1
	if restock_in==0:
		restock()
		restock_in=15
	
func get_menu():
	GM.menus.market_view.update_menu(self)

func restock():
	stock.stuff.clear()
	var stuff = district.territory.get_natural_products()
	for x in level*3:
		var s = stuff.pick_random()
		if s not in stock.stuff.keys():
			stock.add_max(s,level*25)
