class_name Beliefs extends Resource

enum STATS {Happiness,Loyalty,Militancy,Piety,Creativity,Sanity,Mercy}

@export var stats:Dictionary[STATS,float]

func create(c:Pop.CLASS):
	for x in STATS.values():
		stats[x]=0
	if c==Pop.CLASS.Artist:
		stats[STATS.Creativity]+=.5
	if c==Pop.CLASS.Soldier:
		stats[STATS.Militancy]+=.5
	if c==Pop.CLASS.Monk:
		stats[STATS.Piety]+=.5
	if c==Pop.CLASS.Underclass:
		stats[STATS.Happiness]-=.5
		stats[STATS.Loyalty]-=.7
	if c==Pop.CLASS.Nymphoi:
		create_random()
		
func create_individual(p:Person):
	for x in STATS.values():
		stats[x]=0
		stats[x]+=p.beliefs_mods[x]
		
func change_stat(s:STATS,a:float):
	stats[s]=clamp(stats[s]+a,-1,1)



func create_random():
	for x in STATS.values():
		stats[x]=randf_range(-1,1)
