class_name Recipe extends Resource

@export var name:String
@export var id:String
@export var turns:int
@export var inputs:Dictionary[Stuff,int]
@export var outputs:Dictionary[Stuff,int]
@export var exp_to:Dictionary[String,float]
@export var unlocked:bool
