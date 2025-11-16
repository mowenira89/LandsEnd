class_name UnitInventory extends Unit

var person:Person

func init(l:Person):
	person=l
	if cargo==null:
		cargo=Stockpile.new()
		cargo.owner=self
	if outfit==null:
		outfit=Stockpile.new()
		outfit.owner=self	
