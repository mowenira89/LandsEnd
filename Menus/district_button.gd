class_name DistrictButton extends Button
@onready var texture_button: TextureButton = $TextureButton

var district:District

func create(d:District):
	district=d
	if d.building:
		texture_button.texture=d.building.image
		texture_button.visible=true
	else:
		texture_button.visible=false
		

func _on_pressed() -> void:
	GM.menus.district_stats.update_menu(district)


func _on_texture_button_pressed() -> void:
	if texture_button.texture_normal==null:
		pass
