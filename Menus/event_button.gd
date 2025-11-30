class_name EventButton extends HBoxContainer

@onready var button: Button = $Button

var event:Event
var unit:Unit

func create(e:Event,u:Unit=null):
	event=e
	unit=u
	button.text=e.get_message()


func _on_button_gui_input(e: InputEvent) -> void:
	if e.is_action_released("Right Click"):
		unit.remove_event(event)
		unit.movements_allowed_this_turn+=1
		queue_free()
