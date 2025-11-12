class_name Unit extends Resource

@export var leader:Person
@export var inventory:UnitInventory
@export var unit_equipment:UnitEquipment
@export var followers:Population
@export var action_queue:Array[Event]
@export var original_territory:Territory
@export var current_territory:Territory
@export var destination_territory:Territory

func entering_territory(t:Territory):
	current_territory=t
	for x in leader.presence_buffs:
		t.add_buff(x)

func leaving_territory():
	for x in leader.presence_buffs:
		current_territory.remove_buff(x)

func get_total_followers():
	return followers.get_total_population()
	
func change_inventory_capacity():
	pass
