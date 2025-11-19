class_name BuildingExpBuff extends Buff


@export var for_quality:Array[Stuff.QUALITIES]


func check(source):
	var stuff:Stuff
	if source is Stuff:
		stuff=source
	elif source is Recipe:
		stuff=source.outputs[0]
	if !for_quality.is_empty():
		if stuff.qualities.has(for_quality):
			return amt
		else:
			return 0
	else:
		return amt
