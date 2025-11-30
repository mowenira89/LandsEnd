class_name InfoHoverBox extends RichTextLabel

func create(p:Person):
	var s = p.name+"\n"+p.species.name+"\n"+p.title+"\n\n"
	
	if p.inventory.weapon:
		s+=p.inventory.weapon.name
	else:
		s+="No Weapon"
	s+="\n"
	if p.inventory.armor:
		s+p.inventory.armor.name
	else:
		s+="No Armor"
	s+"\n"
	if p.inventory.steed:
		s+="Riding a "+p.inventory.steed.name
	text=s
