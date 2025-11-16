class_name DistrictStats extends ColorRect

@onready var label: Label = $VBoxContainer/Label
@onready var info: RichTextLabel = $VBoxContainer/Info
@onready var build: Button = $VBoxContainer/HBoxContainer/Build

var district:District



func update_menu(d:District):
	district=d
	if district.building or district.construction_time>0:
		build.visible=false
	else:
		build.visible=true
	var l = d.name+" of "
	l+=d.territory.name+"\n"	
	l+=District.TYPES.keys()[d.type]+" "+Biome.TERRAIN.keys()[d.biome.terrain]
	label.text=l
	var i="Resources: "
	if d.biome.terrain!=Biome.TERRAIN.Barren:
		i+="Timber. "
	if !d.discovered_resources.is_empty:
		i+=d.discovered_resources[0].name+"."
	i+="\n\nForage: "
	for x in d.discovered_forage:
		i+=x.name+". "
	i+="\n\nFlora: "
	for x in d.discovered_resources:
		i+=x.name+". "
	i+="\n\nFauna: "
	for x in d.discovered_game:
			i+=x.name+". "
	info.text=i
	GM.menus.switch_side_bottom(self)

func _update_menu():
	update_menu(district)

func _on_build_pressed() -> void:
	GM.menus.build_menu.update_menu(district,district.territory.stockpile)
