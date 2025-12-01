class_name SurveyEvent extends WorkEvent

@export var district:District
@export var unit:Unit
@export var longstride:int
@export var keeneye:int
@export var luck:int


var fauna = district.biome.fauna.duplicate()
var flora = district.biome.flora.duplicate()
var forage = district.biome.forage.duplicate()
var res = district.biome.mineable

func make_plans(p:Population,d,u=null):
	district=d
	unit=u
	population=p
	longstride = unit.get_prowess(Person.PROWESS.LongStrider)
	keeneye = unit.get_prowess(Person.PROWESS.KeenEye)
	luck = unit.get_luck()
	message="Surveying "+d.name
	workers_needed[Pop.CLASS.Follower]=2
	
	for x in fauna:
		fauna[x]+=keeneye+luck
	for x in flora:
		flora[x]+=keeneye+luck
	for x in forage:
		forage[x]+=keeneye+luck
	if res:
		res=res.qualities[Stuff.QUALITIES.Mineable]+keeneye+luck
	
func apply():
	for x in longstride:
			survey()
	
func survey():
	for x in fauna:
		if randi_range(0,100)<fauna[x]:
			district.fauna_spotted(x)
	for x in flora:
		if randi_range(0,100)<flora[x]:
			district.flora_spotted(x)
	for x in forage:
		if randi_range(0,100)<forage[x]:
			district.forage_spotted(x)
	if res:
		if randi_range(0,100)<res:
			district.resource_spotted(res)
		
		
