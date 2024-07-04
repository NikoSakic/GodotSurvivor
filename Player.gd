extends CharacterBody2D
class_name Player
 
const MOVE_SPEED = 260
var damage = 35 
var health = 100 

@onready var raycast = $RayCast2D
@onready var weapon_container :WeaponContainer = $WeaponContainer
@onready var player_shooting : PlayerShooting = $PlayerShooting


signal player_damaged(health_value : int)
signal enemy_killed(score : int)
 
func _ready():
	await get_tree().process_frame
	get_tree().call_group("zombies", "set_player", self)
 
func _physics_process(delta):
	var move_vec = Vector2()
	if Input.is_action_pressed("move_up"):
		move_vec.y -= 1
	if Input.is_action_pressed("move_down"):
		move_vec.y += 1
	if Input.is_action_pressed("move_left"):
		move_vec.x -= 1
	if Input.is_action_pressed("move_right"):
		move_vec.x += 1
	move_vec = move_vec.normalized()
	move_and_collide(move_vec * MOVE_SPEED * delta)
	
	if Input.is_action_just_pressed("restart"):
		get_tree().reload_current_scene()
 
	var look_vec = get_global_mouse_position() - global_position
	global_rotation = atan2(look_vec.y, look_vec.x)
 
func take_damage(value):
	health -= value
	player_damaged.emit(health)
	if health <= 0:
		kill()

func receive_score_from_enemy(score : int):
	enemy_killed.emit(score)

func kill():
	get_tree().reload_current_scene()
