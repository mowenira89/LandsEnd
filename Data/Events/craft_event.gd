class_name CraftEvent extends Event

var unit:Unit
var recipe:Recipe

func make_plans(u:Unit,r:Recipe):
	unit=u
	recipe=r
	message="Crafting "+recipe.name

func apply():
	for x in recipe.inputs:
		if unit.cargo.check_stuff_amount(x)<recipe.inputs[x]:
			return false
	var prod = unit.get_prowess(Person.PROWESS.Productive)/10
	
	for x in recipe.outputs:
		var amt = recipe.outputs[x]
		amt+=amt*prod
		if unit.cargo.check_stuff_amount(x)+amt>unit.cargo.get_capacity(x):
			return false
	
	for x in recipe.inputs:
		unit.cargo.remove_stuff(x,recipe.inputs[x])
	for x in recipe.outputs:
		var amt = recipe.outputs[x]
		amt+=amt*prod	
		unit.cargo.add_stuff(x,amt,true,null,null)
