extends CharacterBody2D
class_name Zombie

const MOVE_SPEED = 200
var health:int = 100 
var dmg = 20
var can_attack = true

@export var HitMarkerSound : AudioStreamPlayer2D = null

@onready var animPlayer = $AnimationPlayer
@onready var attackTimer = $Timer
@onready var raycast = $RayCast2D

var player : Player = null
 
func _ready():
	add_to_group("zombies")
	can_attack = true

func is_dead()->bool:
	return (health <= 0)
 
func _physics_process(delta):
	if player == null:
		return
	if health <= 0:
		return
	var vec_to_player = player.global_position - global_position
	vec_to_player = vec_to_player.normalized()
	global_rotation = atan2(vec_to_player.y, vec_to_player.x)
	move_and_collide(vec_to_player * MOVE_SPEED * delta)
 
	if can_attack == false:
		return
	if raycast.is_colliding():
		var coll = raycast.get_collider()
		if coll != null and coll.name == "Player":
			coll.take_damage(dmg)
			can_attack = false
			attackTimer.start()

 
func take_damage(value):
	if health <= 0:
		return
	health -= value
	if HitMarkerSound != null:
		HitMarkerSound.play()
	if health <= 0:
		kill()

func kill():
	player.receive_score_from_enemy(50)
	animPlayer.play("zombie_death")
 
func set_player(p):
	player = p

func _on_timer_timeout():
	can_attack = true
