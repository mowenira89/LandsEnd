class_name TerritoryStats extends ColorRect

var territory:Territory

@onready var _name: Label = $VBoxContainer/Name
@onready var info: RichTextLabel = $VBoxContainer/Info


func update_menu(t:Territory):
	territory=t
	_name.text = t.name
	var resources = "Resources: "
	var r = []
	var flora = []
	var fauna = []
	var forage = []
	for x in territory.districts:
		if x.biome.mineable and x.biome.mineable not in r:
			r.append(x.biome.mineable)
		for y in x.biome.fauna.keys():
			if y not in fauna:
				fauna.append(y)
		for y in x.biome.flora:
			if y not in flora:
				flora.append(y)
		for y in x.biome.forage:
			if y not in forage:
				forage.append(y)
	for x in r:
		resources+=x.name+". "
	resources+="\n\nForage: "
	for x in forage:
		resources+=x.name+". "
	resources+="\n\nFlora: "
	for x in flora:
		resources+=x.name+". "
	resources+="\n\nFauna: " 
	for x in fauna:
		resources+=x.name+". "
	
	GM.menus.switch_side_top(self)
			
func _update_menu():
	update_menu(territory)
