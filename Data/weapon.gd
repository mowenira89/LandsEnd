class_name Weapon extends Stuff

enum DAMAGE_TYPE {Slash,Pierce,Blunt,Missile}

@export var damage_type:DAMAGE_TYPE
@export var damage_boost:float
@export var buff:Array[Buff]
@export var prowess_bonus:Array[Person.PROWESS]
