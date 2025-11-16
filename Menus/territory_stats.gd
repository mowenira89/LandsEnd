class_name TerritoryStats extends ColorRect

var territory:Territory

@onready var _name: Label = $VBoxContainer/Name
@onready var info: RichTextLabel = $VBoxContainer/Info


func update_menu(t:Territory):
	territory=t
	_name.text = t.name
	var resources = "Resources: "
	var r = territory.get_known_resources()
	var flora = territory.get_known_flora()
	var fauna = territory.get_known_fauna()
	var forage = []
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
	info.text=resources
	GM.menus.switch_side_top(self)
			
func _update_menu():
	update_menu(territory)
