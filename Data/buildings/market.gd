class_name Market extends Building

#the market should show only items found in the territory until it is upgraded to a merchant

var stock:Stockpile

func create(d:District):
	super(d)
	stock=Stockpile.new()
	stock.create(null,null,self)

	
func get_menu():
	GM.menus.market_view.update_menu(self)
