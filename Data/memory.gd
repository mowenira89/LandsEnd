class_name Memory extends Resource

var month:int
var week:int
var year:int
var turn:int
var good:bool=true
var turns_to_remember:int
var owner
var memory:String=""
var stat_mod:Dictionary[Beliefs.STATS,float]

func create(o,turns:int,m:String,sm:Dictionary={}):
	owner=o
	memory=m
	stat_mod=sm
	turns_to_remember=turns
	month=GM.month
	week=GM.week
	year=GM.year

func end_turn():
	turns_to_remember-=1
	if turns_to_remember==0:
		owner.memories.erase(self)
