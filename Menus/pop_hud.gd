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

@onready var idles:Dictionary[Pop.CLASS,Label]= {
	Pop.CLASS.Follower:idle_followers,
	Pop.CLASS.Artist:idle_artists,
	Pop.CLASS.Monk:idle_monks,
	Pop.CLASS.Soldier:idle_soldiers
}

@onready var totals:Dictionary[Pop.CLASS,Label]= {
	Pop.CLASS.Follower:total_followers,
	Pop.CLASS.Artist:total_artists,
	Pop.CLASS.Monk:total_monks,
	Pop.CLASS.Soldier:total_soldiers
}

@onready var employed:Dictionary[Pop.CLASS,Label]= {
	Pop.CLASS.Follower:employed_followers,
	Pop.CLASS.Artist:employed_artists,
	Pop.CLASS.Monk:employed_monks,
	Pop.CLASS.Soldier:employed_soldiers
}


func update_menu(t:Territory):
	if t:
		territory=t
		var breakdown = territory.population.get_pop_breakdown()
		var needed = territory.get_jobs()
		for x in idles:
			idles[x].text=str(max(breakdown[x]-needed[x],0))
			employed[x].text=str(needed[x])
			totals[x].text=str(breakdown[x])
	
func _update_menu():
	update_menu(territory)
	
