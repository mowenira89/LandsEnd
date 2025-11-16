class_name EventButton extends Button


var event:Event
var unit:Unit

func create(e:Event,u:Unit=null):
	event=e
	unit=u

func _on_x_pressed() -> void:
	unit.action_queue.erase(event)
	queue_free()
