class_name School extends Building

enum SUBJECTS {Art,Military,Religion,Farming,Magic,TechnicalResearch}

var lecturers:Array[Person]=[null,null,null,null]
var subjects:Array[SUBJECTS]
var storeroom:Stockpile
var lectures:Array[Lecture]=[]
var class_room_size:int

func end_turn():
	for x in lectures:
		x.end_turn()		
			
