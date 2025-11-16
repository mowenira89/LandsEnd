class_name School extends Building

enum SUBJECTS {Art,Military,Religion,Farming,Magic,TechnicalResearch}

var lecturers:Array[Person]=[null,null,null,null]
var subjects:Array[SUBJECTS]
var storeroom:Stockpile
@export var lecture_slots:int
@export var lectures:Array[Lecture]=[]
@export var class_room_size:int

func end_turn():
	for x in lectures:
		x.end_turn()		
			
