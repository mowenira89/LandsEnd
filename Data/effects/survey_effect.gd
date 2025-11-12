class_name SurveyEffect extends Effect

@export var district:District


func init():
	district.territory.change_temp_jobs(Pop.CLASS.Follower,2)	

func apply():
	district.surveyed=true

func on_removal():
	district.territory.change_temp_jobs(Pop.CLASS.Follower,-2)	
