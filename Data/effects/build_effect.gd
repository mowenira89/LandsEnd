class_name BuildEffect extends Effect

@export var building:Building
@export var district:District
@export var stockpile:Stockpile
@export var population:Population

@export var holding_materials:Dictionary[Stuff,int]

func create(b:Building,d:District,s:Stockpile):
	building=b
	district=d
	stockpile=s

func check()->bool:
	var proceed=true
	for x in building.construction_materials:
		if stockpile.check_stuff_amount(x)>=building.construction_materials[x]:
			holding_materials[x]=building.construction_materials[x]
		else:
			proceed=false
			GM.menus.show_alert("Not enough materials.")
			break
	if proceed:
		return true
	return false
		


func init():
	for x in holding_materials:
			stockpile.remove_stuff(x,holding_materials[x])
	district.construction_time=building.construction_time
	print(district.construction_time)
	
func per_turn(turn):
	district.construction_time-=1
	
func apply():
		district.building=building.duplicate()
		district.building.create(district)

func on_removal(turns):
	if turns>0:
		for x in holding_materials:
			stockpile.add_stuff(x,holding_materials[x])
	
