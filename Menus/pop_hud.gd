class_name PopHud extends ColorRect

@onready var total_followers: Label = $MarginContainer/HBoxContainer/VBoxContainer2/TotalFollowers
@onready var idle_followers: Label = $MarginContainer/HBoxContainer/VBoxContainer2/IdleFollowers
@onready var employed_followers: Label = $MarginContainer/HBoxContainer/VBoxContainer2/EmployedFollowers
@onready var total_soldiers: Label = $MarginContainer/HBoxContainer/VBoxContainer3/TotalSoldiers
@onready var idle_soldiers: Label = $MarginContainer/HBoxContainer/VBoxContainer3/IdleSoldiers
@onready var employed_soldiers: Label = $MarginContainer/HBoxContainer/VBoxContainer3/EmployedSoldiers
@onready var total_monks: Label = $MarginContainer/HBoxContainer/VBoxContainer4/TotalMonks
@onready var idle_monks: Label = $MarginContainer/HBoxContainer/VBoxContainer4/IdleMonks
@onready var employed_monks: Label = $MarginContainer/HBoxContainer/VBoxContainer4/EmployedMonks
@onready var total_artists: Label = $MarginContainer/HBoxContainer/VBoxContainer5/TotalArtists
@onready var idle_artists: Label = $MarginContainer/HBoxContainer/VBoxContainer5/IdleArtists
@onready var employed_artists: Label = $MarginContainer/HBoxContainer/VBoxContainer5/EmployedArtists

var territory:Territory

func update_menu(t:Territory):
	territory=t
	
	
func _update_menu():
	update_menu(territory)
