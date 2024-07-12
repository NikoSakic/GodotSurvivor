extends Node2D
class_name EnemyShootingComponent

@export var bullet_scene : Area2D
@export var damage:int
@export var max_attack_range: int
@export var attack_cooldown:float

var target : Player = null
var can_shoot:bool = true

func _ready():
	can_shoot = true

func setPlayer(player):
	target = player

func attack():
	print("attack")
	
func _process(_delta):
	if target == null:
		return
	if !can_shoot:
		return
	if target.global_position.distance_to(global_position) <= max_attack_range:
		attack()
		can_shoot = false
		await get_tree().create_timer(attack_cooldown).timeout
		can_shoot = true
