class_name LootTable extends Resource

var table:Dictionary = {}
var territory:Territory

func create(d:Dictionary,luck=0):
	
	d = d.duplicate()
	var total_weight=0
	var cumulative=0
	var r
	var target:Stuff=null

	if luck>0:
		for x in d:
			if d[x]>50:
				d[x]-=luck
			else:
				d[x]+=luck
	
	for x in d:
		total_weight+=d[x]
	cumulative = randf_range(0,total_weight)
	for x in d:
		cumulative+=d[x]
		if r<cumulative:
			target=x
			break
	return target
