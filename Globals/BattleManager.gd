extends Node

signal new_battle

enum TARGETS {Indv,Self,Opponent,Ally,AdjOpponents,Allies,Friendlies,AllOpponents,All,RandomOpponent,RandomAlly,Random}
var battle:BattleScreen

var event_queue:Array[BattleEvent]
