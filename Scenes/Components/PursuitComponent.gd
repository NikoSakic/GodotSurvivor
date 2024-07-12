extends Node2D
class_name PursuitComponent

@export var char_body :CharacterBody2D
@export var move_speed : float = 200
@export var goal_range : float = 400
var target:Node2D


func set_target(new_target):
	target = new_target
	
func _physics_process(delta):
	var vec_to_player = target.global_position - char_body.global_position
	if vec_to_player.length() <= goal_range:
		return
	vec_to_player = vec_to_player.normalized()
	char_body.global_rotation = atan2(vec_to_player.y, vec_to_player.x)
	char_body.move_and_collide(vec_to_player * move_speed * delta)
