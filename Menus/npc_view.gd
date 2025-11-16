class_name NPCView extends ColorRect
@onready var happiness: ProgressBar = $MarginContainer/VBoxContainer2/HBoxContainer/VBoxContainer3/Happiness
@onready var loyalty: ProgressBar = $MarginContainer/VBoxContainer2/HBoxContainer/VBoxContainer3/Loyalty
@onready var militancy: ProgressBar = $MarginContainer/VBoxContainer2/HBoxContainer/VBoxContainer3/Militancy
@onready var piety: ProgressBar = $MarginContainer/VBoxContainer2/HBoxContainer/VBoxContainer3/Piety
@onready var creativity: ProgressBar = $MarginContainer/VBoxContainer2/HBoxContainer/VBoxContainer3/Creativity
@onready var ability_buttons: VBoxContainer = $MarginContainer/VBoxContainer2/AbilityButtons

func update_menu(npc:Person):
	pass
