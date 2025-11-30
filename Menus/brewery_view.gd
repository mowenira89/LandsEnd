class_name DistilleryView extends BasicBuildingView

@onready var selector_button: SelectorButton = $MarginContainer/HBoxContainer/VBoxContainer/HBoxContainer/ProductionContainers/VBoxContainer/SelectorButton
@onready var containers_choice: HBoxContainer = $MarginContainer/HBoxContainer/VBoxContainer/HBoxContainer/ProductionContainers/VBoxContainer/Containers_Choice

func update_menu(b:Building):
	super(b)
	selector_button.create(b.container)
	containers_choice.visible=false

func _on_selector_button_removing(b:SelectorButton) -> void:
	selector_button.create(null)


func _on_selector_button_open(b:SelectorButton) -> void:
	containers_choice.visible=true


func _on_selector_button_clicked(b:SelectorButton) -> void:	
	containers_choice.visible=true


func _on_barrels_pressed() -> void:
	building.container=RM.stuff["Barrel"]
	_update_menu()

func _on_amphorae_pressed() -> void:
	building.container=RM.stuff["Amphora"]
	_update_menu()
