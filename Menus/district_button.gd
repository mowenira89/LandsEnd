class_name DistrictButton extends ColorRect
@onready var texture_button: TextureButton = $TextureButton
@onready var construction: ColorRect = $TextureButton/Construction
@onready var construction_remaining: Label = $TextureButton/Construction/ConstructionRemaining
@onready var selector_button: Button = $SelectorButton

var district:District
signal select_district

const colors = {
	District.TYPES.Wild:"#615100",
	District.TYPES.Sacred:"#ae9300",
	District.TYPES.Agricultural:"#349300",
	District.TYPES.Industrial:"#916e50",
	District.TYPES.Residential:"#3b8097"
}

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
	color=colors[district.type]


func _on_texture_button_pressed() -> void:
	district.building.get_menu()


func _on_selector_button_gui_input(event: InputEvent) -> void:
	if event.is_action_pressed("Click"):
		GM.menus.send_data.emit(district)
		#select_district.emit(district)
	elif event.is_action_released("Right Click"):
		GM.menus.send_data.emit(null)
		GM.menus.switch_side_bottom(GM.menus.previous_side_bottom)
		#select_district.emit(null)

func set_for_target():
	selector_button.visible=true
	
func untarget():
	selector_button.visible=false


func _on_selector_button_mouse_entered() -> void:
	GM.menus.district_stats.update_menu(district)


func _on_selector_button_mouse_exited() -> void:
	pass


func _on_gui_input(event: InputEvent) -> void:
	if event.is_action_released("Click"):
		GM.menus.district_stats.update_menu(district)
