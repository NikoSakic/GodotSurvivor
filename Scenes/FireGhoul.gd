extends CharacterBody2D

@export var player:Node2D

func _ready():
	$PursuitComponent.set_target(player)
	$EnemyShootingComponent.set_player(player)
