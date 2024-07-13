extends Node2D
class_name EnemyShootingComponent

@export var bullet_scene : PackedScene
@export var damage:int
@export var max_attack_range: int
@export var attack_cooldown:float
@export var bullet_spawn_point : Node2D

var target : Player = null
var can_shoot:bool = true

func _ready():
	can_shoot = true

func set_player(player):
	target = player

func attack():
	var new_bullet = bullet_scene.instantiate()
	new_bullet.global_position = bullet_spawn_point.global_position
	var look_vec = target.position - bullet_spawn_point.global_position
	new_bullet.global_rotation = atan2(look_vec.y, look_vec.x)
	new_bullet.set_damage(damage)
	get_tree().root.add_child(new_bullet)
	
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
