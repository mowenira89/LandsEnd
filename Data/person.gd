class_name Person extends Resource

@export var title:String
@export var name:String
@export var image:Texture2D
@export var abilities:Array[Ability]
@export var presence_buffs:Array[Buff]
@export var boss_buffs:Array[Buff]

func init():
	name=""
