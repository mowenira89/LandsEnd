class_name ChangeDistrictEvent extends Event

var district:District
var changed_to:District.TYPES

func apply():
	district.type=changed_to
