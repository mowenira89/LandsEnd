class_name DistrictButton extends Button
@onready var texture_button: TextureButton = $TextureButton
@onready var construction: ColorRect = $TextureButton/Construction
@onready var construction_remaining: Label = $TextureButton/Construction/ConstructionRemaining
@onready var selector_button: Button = $SelectorButton

var district:District
signal select_district

func create(d:District):
	district=d
	if d.building:
		texture_button.visible=true
		texture_button.texture_normal=d.building.image
	else:
		texture_button.visible=false
	if texture_button.texture_normal==null:
		texture_button.mouse_filter=Control.MOUSE_FILTER_IGNORE
	else:
		texture_button.mouse_filter=Control.MOUSE_FILTER_STOP
	if d.construction_time>0:
		construction.visible=true
		construction_remaining.text=str(d.construction_time)
	else:
		construction.visible=false
	selector_button.visible=false

func _on_pressed() -> void:
	GM.menus.district_stats.update_menu(district)


func _on_texture_button_pressed() -> void:
	district.building.get_menu()
	GM.menus.building_view_bottom.update_menu(district.building)


func _on_selector_button_gui_input(event: InputEvent) -> void:
	if event.is_action_pressed("Click"):
		select_district.emit(district)
	elif event.is_action_released("Right Click"):
		select_district.emit(null)

func set_for_target():
	selector_button.visible=true
	
func untarget():
	selector_button.visible=false
