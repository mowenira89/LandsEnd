class_name Cookhouse extends Building


func end_turn():
	super()
	var potential_recipes = []
	var total=0
	for x in this_building_recipes.values():
		if x is CookhouseRecipe:
			if !x.unlocked:
				var proceed=true
				for i in x.inputs:
					if district.territory.stockpile.check_stuff_amount(i)<0:
						proceed=false
						break		
				if proceed:
					potential_recipes.append(x)				
						
			else:
				total+=1
	var maybe = potential_recipes.pick_random()
	if randi_range(1,100)<maybe.difficulty+total:
		maybe.unlocked=true
		GM.menus.end_turn_box.get_message("Your "+name+" in "+district.name+" have invented "+maybe.name+"!")
