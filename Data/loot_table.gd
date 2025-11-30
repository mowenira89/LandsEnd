class_name LootTable extends Resource

var table:Dictionary = {}
var territory:Territory
var total_weight=0

func create(d:Dictionary,luck=0):
	
	table = d.duplicate()
	
	for x in table:
		total_weight+=table[x]
	
	luck = 0 if !luck else luck
	if luck>0:
		for x in table:
			if table[x]>50:
				table[x]-=luck
			else:
				table[x]+=luck
			
			
	

func roll():
	var cumulative=0
	var r
	var target:Stuff=null
	r = randf_range(0,total_weight)
	for x in table:
		cumulative+=table[x]
		if r<cumulative:
			target=x
			break
	return target
