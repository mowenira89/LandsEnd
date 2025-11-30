class_name LectureSelectWindow extends Control
@onready var vbox: VBoxContainer = $MarginContainer/MarginContainer/ScrollContainer/VBoxContainer
@onready var info: RichTextLabel = $MarginContainer/MarginContainer/VBoxContainer/RichTextLabel



func update_menu(s:Array[Lecture]):
	for x in s:
		var button = Button.new()
		vbox.add_child(button)
		button.text=x.name
		button.pressed.connect(func():GM.menus.send_data.emit.bind(x))
		button.mouse_entered.connect(func(y=x):info.text=y.desc)
		button.mouse_exited.connect(func():info.text="")
	GM.menus.switch_side_bottom(self)
