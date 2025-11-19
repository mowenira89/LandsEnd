class_name Buffs extends Resource

var buffs:Array[Buff]=[]
var owner

func create(o):
	owner=o

func add_buff(b:Buff):
	b.init(owner)
	buffs.append(b)
	
func remove_buff(b:Buff):
	if b in buffs:
		buffs.erase(b)

func return_buff_amount(s:Stats.STATS):
	var r=0
	for x in buffs:
		if x.stat==s:
			r+=x.amt
	return r
	
func get_buffs_total(type:Buff.TYPE,research:Research=null):
	var r = 0
	for x in buffs:
		if type in x.type:
			if x is ResearchBuff:
				if research==x.research:
					r+=x.type[type]
					continue
			r+=x.type[type]
	return r
	
