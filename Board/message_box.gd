class_name EndTurnBox extends ColorRect

var messages:Array[String]=[]
@onready var message_container: VBoxContainer = $MarginContainer/VBoxContainer/ScrollContainer/MessageContainer
@onready var turn_label: Label = $MarginContainer/VBoxContainer/TurnLabel
@onready var start_turn: Button = $MarginContainer/VBoxContainer/StartTurn


func _ready() -> void:
	GM.end_turn_message.connect(get_message)

func get_message(s:String):
	messages.append(s)
	
func display_messages():
	
	turn_label.text=GM.MONTHS.keys()[GM.month]+" Week "+str(GM.week)
	for x in messages:
		var label = Label.new()
		message_container.append(label)
		label.text=x
	start_turn.text = "Begin turn "+str(GM.turns)


func _on_start_turn_pressed() -> void:
	messages.clear()
	for x in message_container.get_children():
		x.queue_free()
