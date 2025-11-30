class_name School extends Building

enum SUBJECTS {Art,Military,Religion,Farming,Magic,TechnicalResearch}
@export var lectures:Array[Lecture]
var lecturers:Array[Person]=[null,null,null,null]
var storeroom:Stockpile
@export var lecture_slots:int
@export var class_room_size:int

var pupils={
	0:[null,null,null],
	1:[null,null,null],
	2:[null,null,null],
	3:[null,null,null],
}

func end_turn():
	for x in producing_this_turn:
		if x is Lecture:
			x.end_turn()
	process_pupils()		
			
func process_pupils():
	for c in pupils:
		if producing_this_turn[c] is Lecture:
			var l = producing_this_turn[c]
			for p in pupils[c]:
				if p:
					for s in l.conveys_prowess:
						p.learn(s,1,l)
				
	
	
	
func get_production_options():
	var r:Array[String]=["Lecture"]
	return r
	
func get_menu():
	GM.menus.school_view.update_menu(self)

func add_lecturer(p:Person,c:int):
	lecturers[c]=p
	if producing_this_turn is Lecture:
		producing_this_turn[c].add_lecturer(p)
	
	
func add_lecture(l:Lecture,i:int):
	producing_this_turn[i]=l
	producing_this_turn[i].make_plans(lecturers[i],self)

func add_pupil(p:Person,c:int,seat:int):
	pupils[c][seat]=p
		
