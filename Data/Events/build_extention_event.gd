class_name BuildExtentionEvent extends Event


@export var building:Building
@export var index:int
@export var stockpile:Stockpile
@export var population:Population
@export var extention:Building

@export var holding_materials:Dictionary[Stuff,int]

func make_plans(b:Building,s:Stockpile,e:Building,i:int):
	building=b
	index=i
	extention=e
	stockpile=s

func check(d:District=null,t:Territory=null,b:Building=null,u:Unit=null)->bool:
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
	building.extention_construction[index]=extention.construction_time
	message="Building "+extention.name
	
func per_turn(turn):
	building.extention_construction[index]-=1
	
func apply():
		building.get_extention(extention)
		building.extentions[index]=extention

func on_removal(turns:int=0):
	if turns>0:
		for x in holding_materials:
			stockpile.add_stuff(x,holding_materials[x])
	 
