class_name Spell extends Resource

@export var name:String
@export var learning_threshold:float
@export var affinity:Stuff.MYSTIC
@export var target:BattleManager.TARGETS
@export var cost:float
@export var piety_multiplier:bool
@export var life_drain:bool
@export var spiritual_pollution:float
@export var battle_effects:Array[BattleEffect]

@export_multiline var battle_desc:String
@export_multiline var out_of_battle_desc:String


func apply(e:BattleEvent):
	for x in battle_effects:
		x.apply(e)
