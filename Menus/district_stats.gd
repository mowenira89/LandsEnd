class_name DistrictStats extends ColorRect

@onready var label: Label = $VBoxContainer/Label
@onready var info: RichTextLabel = $VBoxContainer/Info
@onready var build: Button = $VBoxContainer/HBoxContainer/Build
@onready var survey: Button = $VBoxContainer/HBoxContainer/Survey

var district:District



func update_menu(d:District):
	district=d
	var l = "District "
	l+=str(d.index)+" of "
	l+=d.territory.name+"\n"
	if d.surveyed:
		l+=District.TYPES.keys()[d.type]+" "+Biome.TERRAIN.keys()[d.biome.terrain]
	else:
		l+="Wild???"
	label.text=l
	var i="Resources: ???\n\nForage: ???\n\nFlora: ???\n\nFauna: ???"
	if d.surveyed:
		i="Resources: "
		if d.biome.terrain!=Biome.TERRAIN.Barren:
			i+="Timber. "
		if d.biome.mineable:
			i+=d.biome.mineable.name+"."
		i+="\n\nForage: "
		for x in d.biome.forage:
			i+=x.name+". "
		i+="\n\nFlora: "
		for x in d.biome.flora:
			i+=x.name+". "
		i+="\n\nFauna: "
		for x in d.biome.fauna:
			i+=x.name+". "
	info.text=i
	if d.surveyed:
		survey.visible=false
	else:
		survey.visible=true
	GM.menus.switch_side_bottom(self)

func _on_build_pressed() -> void:
	GM.menus.build_menu.update_menu(district)


func _on_survey_toggled(toggled_on: bool) -> void:
	if toggled_on:
		var new_event = Event.new()
		var id=district.territory.name+str(district.index)+"survey"
		new_event.create(id)
		var new_effect = SurveyEffect.new()
		new_effect.district=district
		new_event.effects.append(new_effect)
		GM.add_event(new_event)
	else:
		var id = district.territory.name+str(district.index)+"survey"
		GM.remove_event(id)
