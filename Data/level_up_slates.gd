class_name LevelUpSlates extends Resource

@export var slates:Dictionary[int,LevelUpSlate] = {
	2:null,
	3:null,
	4:null,
	5:null,
	6:null,
	7:null,
	8:null,
	9:null,
	10:null,
} 

var owner:Building

func init(b:Building):
	owner=b
	
